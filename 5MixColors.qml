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
    visible: false
    color: "black"

    signal everythingLoaded()
    signal gameOver(double score)

    property bool everythingLoadedSignalSuccessfull: false
    property bool gameRunning: false
    property double marginWidth: Math.min(width, height) / 10

    property int gameTime: 30 * 1000
    property double currentScore: 0
    property int timeLeft
    property int numberOfNeededColors: 2


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
        height: marginWidth
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
        height: marginWidth
        fontSizeMode: Text.Normal
        font.pixelSize: fontSizeHelper.contentHeight
        color: "black"
        text: translate.time + (timeLeft / 1000).toFixed(1);
        wrapMode: Text.NoWrap
    }

    Item {
        id: colorBallsContainer
        y: marginWidth * 3 + (parent.height - marginWidth * 4
                              - colorPickerContainer.height - height) / 2
        width: parent.width
        height: parent.height - marginWidth * 6

        Item {
            id: targetBallContainer
            anchors.fill: parent
            anchors.rightMargin: parent.width / 2
            CustomText {
                id: targetBallText
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: targetBallRectangle.top
                    bottomMargin: height * 0.2
                }
                height: Math.min(parent.height / 8, targetBallRectangle.height / 2)
                text: translate.target
            }
            Rectangle {
                id: targetBallRectangle
                height: Math.min(parent.height * 6 / 8, parent.width / 2)
                width: height
                y: (parent.height - targetBallText.height * 1.2 - height) / 2
                x: (parent.width - width) / 2
                radius: height / 2
                color: "#FFFFFF"
                function setColor(newColor) {
                    targetBallRectangleColorAnimation.from = color
                    targetBallRectangleColorAnimation.to = newColor
                    targetBallRectangleColorAnimation.restart()
                }
                ColorAnimation on color {
                    id: targetBallRectangleColorAnimation
                    running: false
                    duration: 250
                }
            }
        }
        Item {
            id: currentColorBallContainer
            anchors.fill: parent
            anchors.leftMargin: parent.width / 2
            CustomText {
                id: currentColorBallText
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: currentColorBallRectangle.top
                    bottomMargin: height * 0.2
                }
                height: Math.min(parent.height / 8, currentColorBallRectangle.height / 2)
                text: translate.current
            }
            Rectangle {
                id: currentColorBallRectangle
                height: Math.min(parent.height * 6 / 8, parent.width / 2)
                width: height
                y: (parent.height - currentColorBallText.height * 1.2 - height) / 2
                x: (parent.width - width) / 2
                radius: height / 2
                color: "#FFFFFF"
                function setColor(newColor) {
                    currentColorBallRectangleColorAnimation.from = color
                    currentColorBallRectangleColorAnimation.to = newColor
                    currentColorBallRectangleColorAnimation.restart()
                }
                ColorAnimation on color {
                    id: currentColorBallRectangleColorAnimation
                    running: false
                    duration: 250
                }
            }
        }
    }

    Item {
        id: colorPickerContainer
        width: parent.width
        height: marginWidth * 2
        y: parent.height - marginWidth * 3

        CustomText {
            id: numberOfColorsNeededText
            width: parent.width
            height: currentColorBallText.contentHeight * 1.6
            anchors.bottom: colorPicker.top
            font.pixelSize: currentColorBallText.contentHeight * 0.8
            text: translate.choose + numberOfNeededColors
        }

        Grid {
            id: colorPicker
            spacing: marginWidth / 5
            anchors.centerIn: parent

            property double maxColorWidth: parent.width * 0.8 / 4
            property double maxColorHeight: parent.height * 0.95 / colorPicker.rows
            property bool maxWider:
                (maxColorWidth / maxColorHeight > 2 ? true : false)

            property double colorWidth:
                (maxWider ? maxColorHeight * 2 : maxColorWidth)
            property double colorHeight:
                (maxWider ? maxColorHeight : maxColorWidth / 2)


            columns: 4
            rows: 2
            Repeater {
                id: colorsRepeater
                onCountChanged: {
                    if (count == model && count > 0)
                        generateColorFromAvailable(2)
                }
                model: 8
                Item {
                    property var color: randomColorArray()
                    property bool isActive: false

                    width: colorPicker.colorWidth
                    height: colorPicker.colorHeight

                    PixelImage {
                        id: colorPickerImage
                        anchors.fill: parent
                        source: "qrc:/assets/images/color_button.png"
                    }
                    ColorOverlay {
                        anchors.fill: colorPickerImage
                        source: colorPickerImage
                        color: valuesToColor(parent.color[0],
                                             parent.color[1],
                                             parent.color[2])
                    }
                    PixelImage {
                        anchors.fill: parent
                        visible: parent.isActive
                        source: "qrc:/assets/images/color_button_active_frame.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            parent.isActive = !parent.isActive
                            calculateCurrentBallColor()
                        }
                    }
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

    function calculateCurrentBallColor() {
        var nR = 0, nG = 0, nB = 0, noActive = 0
        for (var i = 0 ; i < colorsRepeater.count ; i++) {
            if (colorsRepeater.itemAt(i).isActive) {
                noActive++
                nR += colorsRepeater.itemAt(i).color[0]
                nG += colorsRepeater.itemAt(i).color[1]
                nB += colorsRepeater.itemAt(i).color[2]
            }
        }
        if (noActive) {
            nR = Math.round(nR / noActive)
            nG = Math.round(nG / noActive)
            nB = Math.round(nB / noActive)
            currentColorBallRectangle.setColor(valuesToColor(nR, nG, nB))
        }
        else
            currentColorBallRectangle.setColor("#FFFFFF")
    }

    function valuesToColor(r, g, b) {
        return "#"
                + (r < 16 ? "0" : "")
                + r.toString(16)
                + (g < 16 ? "0" : "")
                + g.toString(16)
                + (b < 16 ? "0" : "")
                + b.toString(16)
    }
    function randomColorArray() {
        return [
                    Math.round(Math.random() * 255),
                    Math.round(Math.random() * 255),
                    Math.round(Math.random() * 255)
                ]
    }
    function generateColorFromAvailable(number) {
        var available = new Array
        var chosen = new Array
        var i, newRandom, range = colorsRepeater.model, tmp
        for (i = 0 ; i < range ; i++)
            available.push(i)
        for (i = 0 ; i < number ; i++) {
            newRandom = Math.floor(Math.random() * range) % range
            chosen.push(available[newRandom])
            tmp = available[range - 1]
            available[range - 1] = available[newRandom]
            available[newRandom] = tmp
            range--;
        }

        var nR = 0, nG = 0, nB = 0
        for (var i = 0 ; i < chosen.length ; i++) {
            nR += colorsRepeater.itemAt(chosen[i]).color[0]
            nG += colorsRepeater.itemAt(chosen[i]).color[1]
            nB += colorsRepeater.itemAt(chosen[i]).color[2]
        }
        nR = Math.round(nR / chosen.length)
        nG = Math.round(nG / chosen.length)
        nB = Math.round(nB / chosen.length)
        targetBallRectangle.setColor(valuesToColor(nR, nG, nB))
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
