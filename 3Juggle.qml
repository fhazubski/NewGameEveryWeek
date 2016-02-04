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

Rectangle {
    id: mainApplicationWindow
    anchors.fill: parent
    visible: true
    color: "black"

    signal everythingLoaded()
    signal gameOver(double score)

    property bool everythingLoadedSignalSuccessfull: false
    property bool gameRunning: false
    property double marginWidth: Math.min(width, height) / 8

    property double currentScore: 0
    property int numberOfBalls: 1
    property int nextScoreAmountTrigger: 4
    property var createdBalls: new Array

    property double ballGravity: 0.0015

    RadialGradient {
        anchors.fill: parent
        cached: true
        verticalOffset: parent.height * 0.2 * Math.random()
        horizontalOffset: parent.width * 0.2 * Math.random()
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#F2F2F2" }
            GradientStop { position: 0.7; color: "#9E9E9E" }
        }
    }

    Rectangle {
        id: pointsTextContainer
        z: 1
        width: pointsText.paintedWidth * 1.2
        height: pointsText.paintedHeight * 1.2
        anchors.horizontalCenter: parent.horizontalCenter
        y: pointsText.y - (height - pointsText.height) / 2
        radius: height / 3
        color: "#88FFFFFF"
    }

    CustomText {
        id: pointsText
        z: 1
        anchors.horizontalCenter: parent.horizontalCenter
        y: marginWidth
        width: (mainApplicationWindow.width - marginWidth * 3) / 2
        height: marginWidth * 1.5
        color: "black"
        text: translate.score + currentScore
        fontSizeMode: Text.Normal
        font.pixelSize: fontSizeHelper.paintedHeight
        wrapMode: Text.NoWrap
        CustomText {
            id: fontSizeHelper
            anchors.fill: parent
            text: translate.score + "1000"
            visible: false
            wrapMode: Text.NoWrap
        }
    }

    Component {
        id: ballComponent
        Rectangle {
            id: ball
            x: -width
            y: -height
            width: dataModel.windowLength / 10
            height: width
            radius: width / 2
            color: randomColor()

            NumberAnimation on x {
                id: ballXAnimation
            }
            SequentialAnimation {
                id: ballYAnimation
                NumberAnimation {
                    id: ballYUpAnimation
                    target: ball
                    property: "y"
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    id: ballYDownAnimation
                    target: ball
                    property: "y"
                    easing.type: Easing.InQuad
                }
            }

            Timer {
                id: gameOverTimer
                running: false
                repeat: false
                onTriggered: {
                    gameOver(currentScore)
                }
            }

            function spawnStartingBall() {
                x = (mainApplicationWindow.width - ball.width) * Math.random()
                y = dataModel.windowHeight - ball.height * 2
            }

            function spawnBall() {
                x = (mainApplicationWindow.width - ball.width) * Math.random() / 2
                        + mainApplicationWindow.width / 4

                y = dataModel.windowHeight
                throwTheBall()
            }

            function throwTheBall() {
                ballXAnimation.stop()
                ballYAnimation.stop()
                gameOverTimer.stop()

                var heightToGain =
                        dataModel.windowHeight * 0.4
                        + dataModel.windowHeight * 0.3 * Math.random()

                ballYUpAnimation.to = y - heightToGain
                ballYUpAnimation.duration =
                        Math.sqrt(heightToGain * 2 / ballGravity)
                var downAnimationDurationMultiplier =
                        Math.ceil((dataModel.windowHeight - y) / height) + 1
                ballYDownAnimation.to =
                        y + (downAnimationDurationMultiplier - 1) * heightToGain
                ballYDownAnimation.duration =
                        Math.sqrt(heightToGain
                                  * downAnimationDurationMultiplier
                                  * 2
                                  / ballGravity)
                var downAnimationDurationMultiplierToHide =
                        (dataModel.windowHeight - y) / height + 1
                var timeToHide =
                        (downAnimationDurationMultiplierToHide + 1)
                        * ballYUpAnimation.duration
                var endXPosition =
                        (dataModel.windowWidth - width) * Math.random()
                var ballXVelocity = (endXPosition - x) / timeToHide
                ballXAnimation.duration =
                        (downAnimationDurationMultiplier + 1)
                        * ballYUpAnimation.duration
                ballXAnimation.to = x + ballXAnimation.duration * ballXVelocity

                gameOverTimer.interval =
                        ballYUpAnimation.duration
                        + ballYDownAnimation.duration

                ballXAnimation.start()
                ballYAnimation.start()
                gameOverTimer.restart()
            }
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        onPressed: {
            var usedPoints = new Array
            var ballCenterX, ballCenterY, ballRadius
            for (var j = createdBalls.length - 1 ; j >= 0 ; j--) {
                ballCenterX = createdBalls[j].x + createdBalls[j].width / 2
                ballCenterY = createdBalls[j].y + createdBalls[j].height / 2
                ballRadius = createdBalls[j].width / 2 * 1.6
                for (var i = 0 ; i < touchPoints.length ; i++) {
                    if (!(i in usedPoints) ) {
                        if (Math.sqrt(
                                    Math.pow(touchPoints[i].x - ballCenterX, 2)
                                    + Math.pow(touchPoints[i].y - ballCenterY, 2))
                                <= ballRadius) {
                            usedPoints.push(i)
                            currentScore++
                            createdBalls[j].throwTheBall();
                            i = touchPoints.length;
                        }
                    }
                }
            }
        }
    }

//    Timer {
//        id: refreshTime
//        interval: 33
//        running: gameRunning
//        repeat: true
//        onTriggered: {
//            timeLeft -= interval
//            if (timeLeft <= 0) {
//                timeLeft = 0
//                gameOver(currentScore)
//                gameRunning = false
//            }
//        }
//    }

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

    onCurrentScoreChanged: {
        if (currentScore >= nextScoreAmountTrigger) {
            numberOfBalls++
            nextScoreAmountTrigger *= 4
            createdBalls.push(ballComponent.createObject(mainApplicationWindow))
            createdBalls[createdBalls.length - 1].spawnBall()
        }
    }

    function startGame() {
        fadeInGame.start()
        everythingLoadedSignalSuccessfull = true
        visible = true
        gameRunning = false
        numberOfBalls = 1
        nextScoreAmountTrigger = 4
        createdBalls.push(ballComponent.createObject(mainApplicationWindow))
        createdBalls[0].spawnStartingBall()
    }

    function pauseGame() {
    }

    function restartGame() {
        gameRunning = false
        currentScore = 0
        numberOfBalls = 1
        nextScoreAmountTrigger = 4

        for (var i = createdBalls.length - 1 ; i >= 0 ; i--)
            createdBalls[i].destroy()
        createdBalls.splice(0, createdBalls.length)

        createdBalls.push(ballComponent.createObject(mainApplicationWindow))
        createdBalls[0].spawnStartingBall()
    }

    function resumeGame() {
    }

    Component.onDestruction: {
        for (var i = createdBalls.length - 1 ; i >= 0 ; i--)
            createdBalls[i].destroy()
        createdBalls.splice(0, createdBalls.length)
    }
}
