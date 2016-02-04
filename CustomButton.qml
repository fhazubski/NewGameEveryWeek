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
    id: multiTouchButton

    antialiasing: false
    border.width: 0
    border.color: "transparent"
    color: "transparent"
    radius: 0
    property alias gradient: buttonContainer.gradient

    property string imageSource
    property string image2Source
    property double image2SizePercent: 0.8
    property bool smoothImage: true
    property bool smoothImage2: true
    property string text
    property double textHeightPercent: (imageSource.length ?  0.7 : 1 )
    property string textColor: "black"
    property string colorOverlayColor: ""
    property bool lightButton: false
    property double brightnessChange: 0.4

    signal pressed()
    signal clicked()

    property alias image: startButton

    Rectangle {
        id: buttonContainer
        anchors.fill: parent

        antialiasing: parent.antialiasing
        border.width: parent.border.width
        border.color: parent.border.color
        color: parent.color
        radius: parent.radius

        Image {
            id: startButton
            visible: colorOverlayColor.length ? false : true
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: imageSource
            sourceSize: Qt.size(width, height)
            smooth: smoothImage

            Image {
                visible: colorOverlayColor.length ? false : true
                anchors.centerIn: parent
                width: parent.width * image2SizePercent
                height: parent.height * image2SizePercent
                fillMode: Image.PreserveAspectFit
                source: image2Source
                sourceSize: Qt.size(width, height)
                smooth: smoothImage2
            }
        }

        ColorOverlay {
            id: buttonColorOverlay
            anchors.fill: startButton
            source: startButton
            visible: colorOverlayColor.length ? true : false
            color: colorOverlayColor
        }

        CustomText {
            anchors.centerIn: parent
            width: {
                if (imageSource.length)
                    return startButton.paintedWidth * textHeightPercent
                else
                    return buttonContainer.width * textHeightPercent
            }
            height: {
                if (imageSource.length)
                    return startButton.paintedHeight * textHeightPercent
                else
                    return buttonContainer.height * textHeightPercent
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            clip: true
            color: textColor
            fontSizeMode: Text.Fit
            font.pixelSize: height
            minimumPixelSize: 3
            text: multiTouchButton.text
        }
    }

    MouseArea {
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: {
            if (imageSource.length)
                return startButton.paintedWidth
            else
                return buttonContainer.width
        }
        height: {
            if (imageSource.length)
                return startButton.paintedHeight
            else
                return buttonContainer.height
        }
        onContainsPressChanged: {
            if (containsPress) {
                multiTouchButtonNotActive.stop()
                multiTouchButtonActive.start()
            }
            else {
                multiTouchButtonActive.stop()
                multiTouchButtonNotActive.start()
            }
        }
        onPressed:
            multiTouchButton.pressed()
        onClicked:
            multiTouchButton.clicked()
    }

    BrightnessContrast {
        anchors.fill: buttonContainer
        source: buttonContainer
        NumberAnimation on brightness {
            id: multiTouchButtonActive
            running: false
            to: (lightButton ? brightnessChange * (-1) : brightnessChange)
            duration: 1
            easing.type: Easing.OutCubic
        }
        NumberAnimation on brightness {
            id: multiTouchButtonNotActive
            running: false
            to: 0
            duration: 1
            easing.type: Easing.InCubic
        }
    }

}

