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

Rectangle {
    id: mainApplicationWindow
    anchors.fill: parent
    visible: false
    color: "black"

    signal everythingLoaded()
    signal gameOver(double score)

    property bool everythingLoadedSignalSuccessfull: false
    property bool gameRunning: false
    property double marginWidth: Math.min(width, height) / 8

    property double currentScore: Math.floor(gameTimeElapsed / 1000)
    property int gameTimeElapsed

    property double shurikenSize: (width + height) / 10


    Rectangle {
        id: pointsTextContainer
        width: pointsText.paintedWidth * 1.2
        height: pointsText.paintedHeight * 1.2
        x: pointsText.x - (width - pointsText.width) / 2
        y: pointsText.y - (height - pointsText.height) / 2
        z: 1
        radius: height / 3
        color: "#88FFFFFF"
    }

    CustomText {
        id: pointsText
        x: (parent.width - width) / 2
        y: marginWidth
        z: 1
        width: (mainApplicationWindow.width - marginWidth * 3) / 2
        height: marginWidth * 1.5
        color: "black"
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

    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/assets/images/ninja_background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: false
    }

    Timer {
        id: spawnShurikens
        interval: 800
        running: gameRunning
        repeat: true
        onTriggered: {
            shurikenComponent.createObject(mainApplicationWindow)
        }
    }

    Component {
        id: shurikenComponent
        Image {
            id: shuriken
            x: (direction == 0 || direction == 2
                ? (mainApplicationWindow.width - width) * Math.random()
                : (direction == 1
                   ? -shurikenSize
                   : mainApplicationWindow.width))
            y: (direction == 0 || direction == 2
                ? (direction == 0
                   ? mainApplicationWindow.height
                   : -shurikenSize)
                : (mainApplicationWindow.height - height) * Math.random() )
            onXChanged: {
                checkIfGameOver()
            }
            onYChanged: {
                checkIfGameOver()
            }
            width: shurikenSize
            height: shurikenSize
            source: "qrc:/assets/images/ninja_star.png"
            fillMode: Image.PreserveAspectFit
            smooth: false
            mirror: (rotationChange < 0 ? true : false)
            property double myRandom: Math.random()
            property double startingRotation: 90 * Math.random()
            property double rotationChange: (Math.random() < 0.5 ? 360 : -360)
            property int fullRotationDuration: 200 + Math.random() * 700
            // 0 - up, 1 - right, 2 - down, 3 - left
            property int direction: Math.floor(Math.random() * 4) % 4
            property double velocity: 0.1 + currentScore / 100
                                      + Math.random() * 0.2
//            Timer {
//                interval: 100
//                running: true
//                onTriggered: {
//                    shurikenRotationAnimation.restart()
//                    shurikenPositionAnimation.restart()
//                    console.log(shuriken.x, shuriken.y, shurikenPositionAnimation.property, shurikenPositionAnimation.to)
//                }
//            }

            RotationAnimation on rotation {
                id: shurikenRotationAnimation
                running: true
                loops: Animation.Infinite
                from: shuriken.startingRotation
                to: shuriken.startingRotation + shuriken.rotationChange
                direction: (shuriken.rotationChange > 0
                            ? RotationAnimation.Clockwise
                            : RotationAnimation.Counterclockwise)
                duration: shuriken.fullRotationDuration
            }
            NumberAnimation {
                id: shurikenPositionAnimation
                running: true
                target: shuriken
                property: (shuriken.direction == 0 || shuriken.direction == 2
                           ? "y" : "x")
                to: {
                    if (shuriken.direction == 0 || shuriken.direction == 3)
                        return -shurikenSize
                    else if (shuriken.direction == 1)
                        return mainApplicationWindow.width
                    else
                        return mainApplicationWindow.height
                }
                duration: (shuriken.velocity > 0
                           ? (shuriken.direction == 0 || shuriken.direction == 2
                              ? mainApplicationWindow.height / shuriken.velocity
                              : mainApplicationWindow.width / shuriken.velocity)
                           : 0)
                onStopped: shuriken.destroy()
            }
            function checkIfGameOver() {
                var centerX = x + width / 2
                var centerY = y + height / 2
                var radius = width / 2
                if (Math.sqrt(Math.pow(playersFinger.mouseX - centerX, 2)
                              + Math.pow(playersFinger.mouseY - centerY, 2))
                        < radius) {
                    gameRunning = false
                    gameOver(currentScore)
                }
            }
        }
    }

    Timer {
        id: refreshTime
        interval: 33
        running: gameRunning
        repeat: true
        onTriggered: {
            gameTimeElapsed += interval
        }
    }

    MouseArea {
        id: playersFinger
        anchors.fill: parent
        onPressed: {
            gameRunning = true
        }
        onReleased: {
            gameRunning = false
            gameOver(currentScore)
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


    Rectangle {
        id: blackDimGame
        anchors.fill: parent
        color: "black"
        opacity: 1
        z: 10

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

    function startGame() {
        fadeInGame.start()
        everythingLoadedSignalSuccessfull = true
        visible = true
        gameRunning = false
        gameTimeElapsed = 0
    }

    function pauseGame() {
    }

    function restartGame() {
        gameRunning = false
        gameTimeElapsed = 0
    }

    function resumeGame() {
    }
}
