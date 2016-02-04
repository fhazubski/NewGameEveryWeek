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

import QtQuick 2.0

Rectangle {
    id: gameCard

    color: "white"
    enabled: gameCardEnabled
    opacity: 0
    scale: 0
    anchors.verticalCenterOffset: 0
    radius: Math.min(width, height) / 20
    layer.enabled: true

    property double bestScoreValue: 0
    property string gameNumber
    property string gameName
    property string gameQMLFile

    onGameNumberChanged: {
        bestScoreValue = saveData.value(gameNumber + "BestScore", 0)
    }

    MouseArea {
        id: outsideWindowPressCatcher
        z: -1
        width: dataModel.windowWidth
        height: dataModel.windowHeight
        anchors.centerIn: parent
        onPressed: {
            hideGameCard()
        }
    }

    MouseArea {
        id: insideWindowPressCatcher
        anchors.fill: parent
    }

    Rectangle {
        id: backButtonContainer
        width: cardObjectsContainer.anchors.margins
        height: width
        anchors.top: parent.top
        anchors.right: parent.right
        color: "transparent"

        PixelImage {
            id: backButton
            anchors.fill: parent
            anchors.margins: gameCard.radius / 2
            source: "qrc:/assets/images/cross.png"
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                hideGameCard()
            }
        }
        DebugRectangle{ debugName: "backButton" }
    }

    Rectangle {
        id: cardObjectsContainer
        anchors.fill: parent
        anchors.margins: dataModel.windowLength / 25
        color: "transparent"

        CustomText {
            id: gameTitle
            width: parent.width
            height: parent.height / 2.8
            text: gameName
            DebugRectangle{ debugName: "gameTitle" }
        }

        GamePreview {
            id: gamePreview
            width: parent.width
            height: parent.height * 0.7 / 2.8
            anchors.top: gameTitle.bottom
            gameNumber: gameCard.gameNumber

            MouseArea {
                id: gamePreviewMouseArea
                anchors.fill: parent
                onClicked: {
                    startGameButton.clicked()
                }
            }
        }

        CustomText {
            id: bestScore
            width: parent.width
            height: parent.height * 0.3 / 2.8
            anchors.top: gamePreview.bottom
            text: translate.bestScore + bestScoreValue
            wrapMode: Text.NoWrap
            DebugRectangle{ debugName: "bestScore" }
        }

        Grid {
            id: buttonsContainer
            width: parent.width
            height: parent.height * 0.8 / 2.8
            anchors.top: bestScore.bottom
            columns: 1
            rowSpacing: height / 8

            CustomButton {
                id: startGameButton
                width: parent.width
                height: (parent.height - parent.rowSpacing) / 2
                imageSource: "qrc:/assets/images/green_button.png"
                text: translate.start
                smoothImage: false
                brightnessChange: -0.4
                onClicked: {
                    fadeOutMainMenu.restart()
                    animationIntoGamePreview.restart()
                    waitToStartTheGameTimer.restart()
                }
                Timer {
                    id: waitToStartTheGameTimer
                    interval: fadeInMainMenu.duration
                    running: false
                    onTriggered: {
                        mainMenu.visible = false
                        gameInterface.visible = true
                        gameInterface.gameQMLFile = gameCard.gameQMLFile
                        gameInterface.gameNumber = gameCard.gameNumber
                        gameInterface.loadGame()
                    }
                }
            }
            CustomButton {
                id: backButton2
                width: parent.width
                height: (parent.height - parent.rowSpacing) / 2
                imageSource: "qrc:/assets/images/red_button_small.png"
                text: translate.back
                smoothImage: false
                brightnessChange: -0.4
                onClicked: {
                    hideGameCard()
                }
            }

            DebugRectangle{ debugName: "buttonsContainer" }
        }
    }

    ParallelAnimation {
        id: fadeInGameCardAnimation
        running: false
        onStarted: gameCard.focus = true
        NumberAnimation {
            target: gameCard
            property: "opacity"
            to: 0.95
            duration: 250
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: gameCard
            property: "scale"
            to: 1
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

    ParallelAnimation {
        id: fadeOutGameCardAnimation
        running: false
        onStarted: mainMenu.focus = true
        NumberAnimation {
            target: gameCard
            property: "opacity"
            to: 0
            duration: 250
            easing.type: Easing.InCubic
        }
        NumberAnimation {
            target: gameCard
            property: "scale"
            to: 0
            duration: 250
            easing.type: Easing.InCubic
        }
    }

    Keys.onBackPressed: {
        hideGameCard()
    }

    ParallelAnimation {
        id: animationIntoGamePreview
        NumberAnimation {
            target: gameCard
            property: "scale"
            to: dataModel.windowHeight / gamePreview.height
            duration: fadeInMainMenu.duration
            easing.type: Easing.OutSine
        }
        NumberAnimation {
            target: gameCard
            property: "anchors.verticalCenterOffset"
            to: gamePreview.height / 3
            duration: fadeInMainMenu.duration
            easing.type: Easing.OutSine
        }
        NumberAnimation {
            target: gameCard
            property: "opacity"
            to: 1
            duration: fadeInMainMenu.duration
            easing.type: Easing.OutSine
        }
    }
    ParallelAnimation {
        id: animationFromGamePreview
        onStarted: gameCard.focus = true
        NumberAnimation {
            target: gameCard
            property: "scale"
            to: 1
            duration: fadeOutMainMenu.duration
            easing.type: Easing.InSine
        }
        NumberAnimation {
            target: gameCard
            property: "anchors.verticalCenterOffset"
            to: 0
            duration: fadeOutMainMenu.duration
            easing.type: Easing.InSine
        }
        NumberAnimation {
            target: gameCard
            property: "opacity"
            to: 0.95
            duration: fadeOutMainMenu.duration
            easing.type: Easing.InSine
        }
    }

    function showGameCard() {
        fadeInGameCardAnimation.restart()
    }

    function hideGameCard() {
        fadeInGameCardAnimation.stop()
        fadeOutGameCardAnimation.start()
    }

    function gameEnded() {
        bestScoreValue = saveData.value(gameNumber + "BestScore", 0)
        animationFromGamePreview.restart()
        fadeInMainMenu.restart()
    }

}
