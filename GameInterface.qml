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
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

Rectangle {
    id: gameInterface

    color: "transparent"

    property string gameNumber
    property string gameQMLFile

    onGameNumberChanged: {
        bestScore = saveData.value(gameNumber + "BestScore", 0)
    }
    property double bestScore: saveData.value(gameNumber + "BestScore", 0)
    property bool loadingGame: false
    property var loadedGame

    focus: visible

    Rectangle {
        id: gameOverlay
        anchors.fill: parent
        z: 1000
        color: "transparent"
        layer.enabled: true

        MouseArea {
            id: eventCatcher
            anchors.fill: parent
            enabled: (pauseMenu.enabled || gameOverScreen.enabled
                      ? true : false)
        }

        PixelImage {
            id: menuButton
            x: width / 8
            y: x
            width: dataModel.windowLength * 3 / 80
            height: width
            source: "qrc:/assets/images/menu_button.png"
            visible: false
        }
        Glow {
            id: menuButtonGlow
            anchors.fill: menuButton
            fast: true
            samples: 4
            radius: 16
            spread: 0.4
            color: "white"
            transparentBorder: true
            source: menuButton
            opacity: 0
            property bool showMenuButtonFlag:
                ((pauseMenu.enabled || gameOverScreen.enabled || loadingGame)
                 ? false : true)
            onShowMenuButtonFlagChanged: {
                if (showMenuButtonFlag) {
                    hideMenuButton.stop()
                    showMenuButton.restart()
                }
                else {
                    showMenuButton.stop()
                    hideMenuButton.restart()
                }
            }

            NumberAnimation on opacity {
                id: showMenuButton
                running: false
                to: 1
                duration: 250
                easing.type: Easing.OutCubic
            }
            NumberAnimation on opacity {
                id: hideMenuButton
                running: false
                to: 0
                duration: 250
                easing.type: Easing.InCubic
            }

        }
        MouseArea {
            id: menuButtonMouseArea
            width: dataModel.windowLength / 20
            height: width
            onPressed: {
                showPauseMenu.restart()
                loadedGame.pauseGame()
            }
        }
        Rectangle {
            id: pauseMenu
            anchors.fill: parent
            color: "#DDFFFFFF"
            opacity: 0
            enabled: (opacity > 0.1 ? true : false)
            Rectangle {
                id: pauseMenuButtonContainer
                anchors.fill: parent
                anchors.topMargin: parent.height / 6
                anchors.leftMargin: parent.width / 6
                anchors.rightMargin: parent.width / 6
                anchors.bottomMargin: parent.height / 6
                color: "transparent"
                CustomButton {
                    id: pauseMenuReturnButton
                    width: parent.width
                    height: parent.height / 4
                    anchors.top: parent.top
                    imageSource: "qrc:/assets/images/green_button.png"
                    text: translate.resume
                    smoothImage: false
                    brightnessChange: -0.4
                    onClicked: {
                        hidePauseMenu.restart()
                        loadedGame.resumeGame()
                    }
                }
                CustomButton {
                    id: pauseMenuRestartButton
                    width: pauseMenuReturnButton.width
                    height: pauseMenuReturnButton.height
                    anchors.centerIn: parent
                    imageSource: "qrc:/assets/images/grey_button.png"
                    text: translate.restart
                    smoothImage: false
                    brightnessChange: -0.4
                    onClicked: {
                        hidePauseMenu.restart()
                        loadedGame.restartGame()
                    }
                }
                CustomButton {
                    id: pauseMenuQuitButton
                    width: pauseMenuReturnButton.width
                    height: pauseMenuReturnButton.height
                    anchors.bottom: parent.bottom
                    imageSource: "qrc:/assets/images/red_button.png"
                    text: translate.quit
                    smoothImage: false
                    brightnessChange: -0.4
                    onClicked: {
                        quitGame()
                    }
                }
            }
            NumberAnimation on opacity {
                id: showPauseMenu
                running: false
                to: 1
                duration: 250
                easing.type: Easing.OutCubic
            }
            NumberAnimation on opacity {
                id: hidePauseMenu
                running: false
                to: 0
                duration: 250
                easing.type: Easing.InCubic
            }
        }
        Rectangle {
            id: gameOverScreen
            anchors.fill: parent
            color: "#DDFFFFFF"
            opacity: 0
            enabled: (opacity > 0.1 ? true : false)
            NumberAnimation on opacity {
                id: showGameOverScreen
                running: false
                to: 1
                duration: 250
                easing.type: Easing.OutCubic
            }
            NumberAnimation on opacity {
                id: hideGameOverScreen
                running: false
                to: 0
                duration: 250
                easing.type: Easing.InCubic
            }
            Rectangle {
                id: gameOverScreenContainer
                anchors.fill: parent
                anchors.topMargin: parent.height / 6
                anchors.leftMargin: parent.width / 6
                anchors.rightMargin: parent.width / 6
                anchors.bottomMargin: parent.height / 6
                color: "transparent"
                CustomText {
                    id: gameOverText
                    width: parent.width
                    height: parent.height / 4
                    text: translate.gameOver
                    color: "black"
                    wrapMode: Text.NoWrap
                }
                CustomText {
                    id: yourScoreText
                    width: parent.width
                    height: parent.height / 8
                    anchors.top: gameOverText.bottom
                    text: translate.yourScore
                    color: "black"
                    wrapMode: Text.NoWrap
                }
                CustomText {
                    id: yourScoreScoreText
                    width: parent.width
                    height: parent.height * 3 / 16
                    anchors.top: yourScoreText.bottom
                    color: "black"
                    wrapMode: Text.NoWrap
                }
                CustomText {
                    id: yourBestScoreText
                    width: parent.width
                    height: parent.height / 8
                    anchors.top: yourScoreScoreText.bottom
                    anchors.topMargin: parent.height / 16
                    color: "black"
                    text: translate.bestScore + bestScore
                    wrapMode: Text.NoWrap
                }
                CustomButton {
                    id: gameOverPlayAgainButton
                    width: parent.width / 2 * 0.9
                    height: parent.height / 4
                    anchors.top: yourBestScoreText.bottom
                    imageSource: "qrc:/assets/images/green_button.png"
                    text: translate.playAgain
                    smoothImage: false
                    brightnessChange: -0.4
                    onClicked: {
                        hideGameOverScreen.restart()
                        loadedGame.restartGame()
                    }
                }
                CustomButton {
                    id: gameOverQuitButton
                    width: parent.width / 2 * 0.9
                    height: parent.height / 4
                    anchors.top: yourBestScoreText.bottom
                    anchors.right: parent.right
                    imageSource: "qrc:/assets/images/red_button.png"
                    text: translate.quit
                    smoothImage: false
                    brightnessChange: -0.4
                    onClicked: {
                        quitGame()
                    }
                }
            }
        }
    }

    Connections {
        target: (typeof(loadedGame) === "undefined" ? gameInterface : loadedGame)
        ignoreUnknownSignals: true
        onEverythingLoaded: {
            gameInterface.loadingGame = false
            loadedGame.startGame()
        }
        onGameOver: {
            if (pauseMenu.enabled)
                hidePauseMenu.restart()
            showGameOverScreen.restart()
            yourScoreScoreText.text = score
            if (score > bestScore) {
                saveData.setValue(gameNumber + "BestScore", score)
                bestScore = score
            }
        }
    }

    LoadingCircle {
        id: loadingCircle
        running: loadingGame
        z: 1
    }

    Rectangle {
        id: blackDimGameInterface
        anchors.fill: parent
        color: "black"
        opacity: 0
        z: 1000

        NumberAnimation on opacity {
            id: fadeInGameInterface
            running: false
            to: 0
            duration: 1000
        }
        NumberAnimation on opacity {
            id: fadeOutGameInterface
            running: false
            to: 1
            duration: 500
        }
    }

    Keys.onBackPressed: {
        if (loadingGame)
            quitGame()
        else if (fadeOutGameInterface.running
                || waitToQuitTheGameTimer.running)
            waitToQuitTheGameTimer.triggered()
        else if (pauseMenu.enabled
                 || gameOverScreen.enabled)
            quitGame()
        else
            showPauseMenu.restart()
    }

    function loadGame() {
        blackDimGameInterface.opacity = 0
        pauseMenu.opacity = 0
        gameOverScreen.opacity = 0
        loadingGame = true
        var component = Qt.createComponent(gameQMLFile)
        if (component.status == Component.Ready) {
            loadedGame = component.createObject(gameInterface)
//            var incubator = component.incubateObject(gameInterface)
//            if (incubator.status === Component.Ready) {
//                loadedGame = incubator.object
//            } else {
//                incubator.onStatusChanged = function(status) {
//                    if (status == Component.Ready) {
//                        loadedGame = incubator.object
//                    }
//                }
//            }
        }
        else
            console.error(component.errorString())
    }

    function quitGame() {
        fadeOutGameInterface.restart()
        waitToQuitTheGameTimer.restart()
    }
    Timer {
        id: waitToQuitTheGameTimer
        interval: fadeOutGameInterface.duration
        running: false
        onTriggered: {
            mainMenu.visible = true
            mainMenu.gameEnded()
            gameInterface.visible = false
            if (typeof(loadedGame) != "undefined")
                loadedGame.destroy()
        }
    }
}
