/****************************************************************************
**
** The MIT License (MIT)
**
** Copyright (c) 2016 Filip Hazubski
**
** Permission is hereby granted, free of charge, to any person obtaining a
** copy of this software and associated documentation files (the "Software"),
** to deal in the Software without restriction, including without limitation
** the rights to use, copy, modify, merge, publish, distribute, sublicense,
** and/or sell copies of the Software, and to permit persons to whom the
** Software is furnished to do so, subject to the following conditions:
**
** The above copyright notice and this permission notice shall be included
** in all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
** OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
** OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
** THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**
****************************************************************************/

import QtQuick 2.5
import QtGraphicalEffects 1.0
import QtQuick.Particles 2.0

Rectangle {
    id: mainApplicationWindow
    anchors.fill: parent

    visible: false

    color: "black"

    property bool everythingLoadedSignalSuccessfull: false
    property bool gameRunning: false

    property double tapDotWidthStartValue: dataModel.windowLength / 10
    property double tapDotWidth: tapDotWidthStartValue
    property double objectsMargin: tapDotWidthStartValue / 2
    property int gameTime: 30 * 1000
    property double currentScore: 0
    property int timeLeft
    property var currentDot

    CustomText {
        id: pointsText
        x: objectsMargin
        y: objectsMargin
        width: (mainApplicationWindow.width - objectsMargin * 3) / 2
        height: objectsMargin
        color: "white"
        text: translate.score + currentScore
        fontSizeMode: Text.Normal
        font.pixelSize: fontSizeHelper.contentHeight
        wrapMode: Text.NoWrap
        CustomText {
            id: fontSizeHelper
            anchors.fill: parent
            text: translate.score + "1000"
            visible: false
            wrapMode: Text.NoWrap
        }
    }

    CustomText {
        id: timeText
        x: pointsText.x + pointsText.width + objectsMargin
        y: objectsMargin
        width: (mainApplicationWindow.width - objectsMargin * 3) / 2
        height: objectsMargin
        fontSizeMode: Text.Normal
        font.pixelSize: fontSizeHelper.contentHeight
        color: "white"
        text: translate.time + (timeLeft / 1000).toFixed(1);
        wrapMode: Text.NoWrap
    }

    Timer {
        id: refreshTime
        interval: 33
        running: gameRunning
        repeat: true
        onTriggered: {
            timeLeft -= interval
            if (timeLeft <= 0) {
                timeLeft = 0
                gameOver(currentScore)
                gameRunning = false
            }
        }
    }

    MouseArea {
        id: failCatcher
        anchors.fill: parent
        onPressed: {
            if (currentScore >= 0.5)
                currentScore -= 0.5
            failAnimation.restart()
        }
    }

    Component {
        id: tapDotComponent
        Rectangle {
            id: tapDotObject
            z: 1
            color: "transparent"
            property var effectSource: Rectangle {
                color: randomColor()
                width: tapDotObject.width
                height: tapDotObject.height
                visible: false
            }
            property var destroyAnimation: NumberAnimation {
                running: false
                target: tapDotObject
                property: "scale"
                to: 0
                duration: 100
                easing.type: Easing.InCubic
                onStopped: tapDotObject.destroy()
            }
            Glow {
                anchors.fill: parent
                transparentBorder: true
                fast: true
                color: effectSource.color
                source: effectSource
                radius: 8
                samples: 16
                spread: 0.4
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    if (!gameRunning)
                        gameRunning = true
                    currentScore++
                    spawnNewDot()
                    tapDotObject.enabled = false
                    destroyAnimation.start()
                    destroyDotParticles.createObject(mainApplicationWindow, {
                                                         "x": tapDotObject.x + tapDotObject.width / 2,
                                                         "y": tapDotObject.y + tapDotObject.height / 2,
                                                         "particleWidth": tapDotObject.width / 4,
                                                         "particleColor": effectSource.color
                                                     })
                }
            }

        }
    }

    Component {
        id: destroyDotParticles
        ParticleSystem {
            id: particles

            property alias emitter: emitter
            property string particleSource: "qrc:/assets/images/square_particle.png"
            property string particleWidth
            property string particleColor
            property double emitterMagnitude: dataModel.windowLength / 4

            ImageParticle {
                anchors.fill: parent
                source: particleSource
                width: particleWidth
                height: particleWidth
                smooth: false
                color: particleColor
                rotation: 0
                rotationVariation: 90
                alpha: 0
                colorVariation: 0
            }

            Emitter {
                id: emitter
                anchors.centerIn: parent
                emitRate: 800
                maximumEmitted: emitRate / 50
                lifeSpan: 700
                lifeSpanVariation: 500
                size: particleWidth
                sizeVariation: 0
                velocity: AngleDirection {angleVariation: 180; magnitude: emitterMagnitude; magnitudeVariation: emitterMagnitude * 0.5}
            }

            Timer {
                interval: emitter.lifeSpan - emitter.lifeSpanVariation//1000 / (emitter.emitRate / emitter.maximumEmitted)
                running: true
                onTriggered: {
                    emitter.enabled = false
                }
            }
            Timer {
                interval: emitter.lifeSpan + emitter.lifeSpanVariation * 2
                running: true
                onTriggered: {
                    particles.destroy()
                }
            }
        }

    }

    Component.onCompleted: {
        everythingLoadedRetryTimer.restart()
    }

    Timer {
        id: everythingLoadedRetryTimer
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!everythingLoadedSignalSuccessfull)
                everythingLoaded()
        }
    }

    SequentialAnimation {
        id: failAnimation
        running: false
        ColorAnimation {
            target: mainApplicationWindow
            property: "color"
            from: "#000000"
            to: "#390909"
            duration: 100
            easing.type: Easing.InCubic
        }
        ColorAnimation {
            target: mainApplicationWindow
            property: "color"
            from: "#390909"
            to: "#000000"
            duration: 750
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        id: blackDimGame
        anchors.fill: parent
        color: "black"
        opacity: 1

        NumberAnimation on opacity {
            id: fadeInGame
            running: false
            to: 0
            duration: 1000
        }
        NumberAnimation on opacity {
            id: fadeOutGame
            running: false
            to: 1
            duration: 1000
        }
    }

    signal everythingLoaded()
    signal gameOver(double score)


    function spawnNewDot() {
        var currentWidth = (timeLeft > 20000 ? tapDotWidthStartValue : (timeLeft > 10000 ? tapDotWidthStartValue * 3 / 4 : (timeLeft > 5000) ? tapDotWidthStartValue / 2 : tapDotWidthStartValue / 3 ))
        if (tapDotWidth > currentWidth)
            tapDotWidth = currentWidth
        currentDot = tapDotComponent.createObject(mainApplicationWindow, {
                                                      "x": objectsMargin + (mainApplicationWindow.width - objectsMargin * 2 - tapDotWidth) * Math.random(),
                                                      "y": objectsMargin * 3 + (mainApplicationWindow.height - objectsMargin * 4 - tapDotWidth) * Math.random(),
                                                      "width": tapDotWidth,
                                                      "height": tapDotWidth,})
    }

    function startGame() {
        fadeInGame.start()
        everythingLoadedSignalSuccessfull = true
        visible = true
        timeLeft = gameTime
        spawnNewDot()
        gameRunning = false
    }

    function pauseGame() {
    }

    function restartGame() {
        gameRunning = false
        currentScore = 0
        timeLeft = gameTime
        currentDot.destroyAnimation.restart()
        tapDotWidth = tapDotWidthStartValue
        spawnNewDot()
    }

    function resumeGame() {
    }
}
