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

    property int gameTime: 15 * 1000
    property double currentScore: 0
    property int timeLeft


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
        x: marginWidth
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

    Rectangle {
        id: timeTextContainer
        width: timeText.paintedWidth * 1.2
        height: timeText.paintedHeight * 1.2
        x: timeText.x - (width - timeText.width) / 2
        y: timeText.y - (height - timeText.height) / 2
        z: 1
        radius: height / 3
        color: "#88FFFFFF"
    }

    CustomText {
        id: timeText
        x: pointsText.x + pointsText.width + marginWidth
        y: marginWidth
        z: 1
        width: (mainApplicationWindow.width - marginWidth * 3) / 2
        height: marginWidth * 1.5
        fontSizeMode: Text.Normal
        font.pixelSize: fontSizeHelper.contentHeight
        color: "black"
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
        timeLeft = gameTime
        gameRunning = false
    }

    function pauseGame() {
    }

    function restartGame() {
        gameRunning = false
        currentScore = 0
        timeLeft = gameTime
    }

    function resumeGame() {
    }
}
