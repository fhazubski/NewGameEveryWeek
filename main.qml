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
import QtQuick.Window 2.2
import com.monkeybison.savedata 1.0

Window {
    id: appWindow
    visible: true

    width: (tablet7resolution ? 1024 : (tablet10resolution ? 1280 : 500))
    height: (tablet7resolution ? 600 : (tablet10resolution ? 800 : 889))
    color: "black"

    property alias dataModel: dataModelObject
    property var translate

    DataModel {
        id: dataModelObject
    }

    SaveData {
        id: saveData
    }

    MainMenu {
        id: mainMenu
        anchors.fill: parent
//        anchors.margins: 200
    }

    GameInterface {
        id: gameInterface
        anchors.fill: parent
        visible: false
    }

    Rectangle {
        id: welcomeDimRectangle
        anchors.fill: parent
        color: "black"
        visible: (opacity > 0.001 ? true : false)
        layer.enabled: true
        MouseArea {
            id: eventCatcher
            anchors.fill: parent
            enabled: (parent.opacity > 0.9 ? true : false)
        }

        PixelImage {
            anchors.fill: parent
            source: "qrc:/assets/images/monkey_bison_logo.png"
            anchors.margins: Math.min(parent.width, parent.height) / 8
        }
        Timer {
            id: welcomeScreenTimer
            interval: 3000
            running: true
            onTriggered: {
                welcomeDimRectangleAnimation.start()
            }
        }

        NumberAnimation on opacity {
            id: welcomeDimRectangleAnimation
            running: (debugMode ? true : false)
            to: 0
            duration: 1000
        }
    }

    Component.onCompleted: {
        var component
        if (defaultLanguage == "pl")
            component = Qt.createComponent("qrc:/translations/trPolish.qml")
        else
            component = Qt.createComponent("qrc:/translations/trEnglish.qml")
        if (component.status !== Component.Ready)
            console.log(component.errorString())
        else
            translate = component.createObject(appWindow)
    }

    function randomColor() {
        var random = Math.random()
        if (random < 1 / 6)
            return Qt.rgba(0, 1, Math.random(), 1)
        else if (random < 2 / 6)
            return Qt.rgba(1, 0, Math.random(), 1)
        else if (random < 3 / 6)
            return Qt.rgba(0, Math.random(), 1, 1)
        else if (random < 4 / 6)
            return Qt.rgba(1, Math.random(), 0, 1)
        else if (random < 5 / 6)
            return Qt.rgba(Math.random(), 0, 1, 1)
        else
            return Qt.rgba(Math.random(), 1, 0, 1)
    }
}
