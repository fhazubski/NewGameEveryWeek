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
    id: mainMenu

    color: "transparent"

    property bool gameCardEnabled:
        gameCard.opacity > 0.1 ? true : false
    property bool backgroundAnimationRunning:
        gameInterface.visible > 0.9999 ? false : true

    property alias fadeInMainMenu: fadeInMainMenu
    property alias fadeOutMainMenu: fadeOutMainMenu

    Rectangle {
        id: background
        anchors.fill: parent
        color: "darkGreen"
        MovingTileBackground {
            id: movingTileBackground
            anchors.fill: parent
            tileSource: "qrc:/assets/images/backgroundTile.png"
            opacity: 0.4
            velocity: 0.1
            angle: Math.random() * Math.PI * 2
            animationRunning: backgroundAnimationRunning
            onAnimationRunningChanged: {
                if (!animationRunning) {
                    changeAngleAnimation.stop()
                    changeVelocityAnimation.stop()
                    noChangingAngleTimer.stop()
                }
                else {
                    changeVelocityAnimation.start()
                    noChangingAngleTimer.start()
                }
            }
            Timer {
                id: noChangingAngleTimer
                interval: 1000 + Math.random() * 8000
                running: true
                repeat: false
                onTriggered: {
                    var newAngle = Math.random() * Math.PI * 2
                    var difference =
                            dataModel.differenceBetweenTwoAngles(
                                movingTileBackground.angle, newAngle)
                    changeAngleAnimation.to = newAngle
                    changeAngleAnimation.duration = difference * 1000
                    changeAngleAnimation.start()
                }
            }
            RotationAnimation on angle {
                id: changeAngleAnimation
                running: false
                direction: RotationAnimation.Shortest
                onStopped: {
                    noChangingAngleTimer.interval = 1000 + Math.random() * 8000
                    noChangingAngleTimer.start()
                }
            }
            SequentialAnimation {
                id: changeVelocityAnimation
                running: true
                loops: Animation.Infinite
                NumberAnimation {
                    target: movingTileBackground
                    property: "velocity"
                    to: 0.25
                    duration: 8000
                    easing.type: Easing.OutQuint
                }
                NumberAnimation {
                    target: movingTileBackground
                    property: "velocity"
                    to: 0.1
                    duration: 8000
                    easing.type: Easing.OutInCubic
                }
            }
        }
    }

    PixelImage {
        id: titleImage
        anchors.fill: parent
        anchors.margins: dataModel.windowLength / 30
        anchors.bottomMargin: dataModel.windowHeight * 2 / 3
        source: "qrc:/assets/images/logo.png"
        DebugRectangle{ debugName: "titleImage" }
    }

    ListView {
        id: gamesListView

        enabled: !gameCardEnabled

        anchors.fill: parent
        anchors.margins: dataModel.windowLength / 30
        anchors.topMargin: dataModel.windowHeight / 2
        clip: true
        spacing: dataModel.windowLength / 200

        delegate: gamesDelegate
        model: gamesListModel

        DebugRectangle{ debugName: "gameListView" }
    }

    CustomText {
        id: gamesDelegateTextHelper
        visible: false
        width: gamesListView.width
        height: dataModel.windowLength / 20
        text: {
            var longest = ""
            for (var i = 0 ; i < gamesListModel.count ; i++) {
                if (longest.length < translate.gameNames[gamesListModel.get(i).gameIndex].length)
                    longest = translate.gameNames[gamesListModel.get(i).gameIndex]
            }
            return longest + longest
        }
    }

    Component {
        id: gamesDelegate
        CustomButton {
//            color: "white"
//            border.color: "black"
//            border.width: 2
//            radius: height / 3
            width: gamesListView.width
            height: dataModel.windowLength / 20
            imageSource: "qrc:/assets/images/game_name_bar.png"
            smoothImage: false
            text: (index + 1) + ". " + translate.gameNames[gameIndex]

            brightnessChange: -0.2
//            CustomText {
//                anchors.fill: parent
//                font.pixelSize:
//                    gamesDelegateTextHelper.paintedHeight
//                    / gamesDelegateTextHelper.lineCount
//                text:
//            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    startNewGame(translate.gameNames[gameIndex], gameQML, index)
                }
            }
            DebugRectangle{ debugName: "gameListElement" }
        }
    }

    ListModel {
        id: gamesListModel
        ListElement{ gameIndex: 0; gameQML: "1TapEmOut.qml" }
        ListElement{ gameIndex: 1; gameQML: "2RollTheCat.qml" }
        ListElement{ gameIndex: 2; gameQML: "3Juggle.qml" }
        ListElement{ gameIndex: 3; gameQML: "4AvoidNinjaStars.qml" }
        ListElement{ gameIndex: 4; gameQML: "5MixColors.qml" }
    }

    GameCard {
        id: gameCard
        anchors.centerIn: parent
        width: parent.width - dataModel.windowLength / 20
        height: parent.height - dataModel.windowLength / 20
    }

    Rectangle {
        id: blackDimMainMenu
        anchors.fill: parent
        color: "black"
        opacity: 0

        NumberAnimation on opacity {
            id: fadeInMainMenu
            running: false
            to: 0
            duration: 1000
        }
        NumberAnimation on opacity {
            id: fadeOutMainMenu
            running: false
            to: 1
            duration: 500
        }
    }

    function startNewGame(gameName, gameFile, gameNumber) {
        gameCard.gameName = gameName
        gameCard.gameQMLFile = gameFile
        gameCard.gameNumber = gameNumber
        gameCard.showGameCard()
    }

    function gameEnded() {
        gameCard.gameEnded()
    }

}
