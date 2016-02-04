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

PixelImage {
    id: loadingCircle

    property bool running: false

    anchors.fill: parent
    anchors.margins: Math.min(parent.width, parent.height) / 3
    source: "qrc:/assets/images/loading_circle.png"
    opacity: 0

    Timer {
        interval: 150
        running: parent.running
        repeat: true
        onTriggered: {
            loadingCircle.rotation += 90
        }
    }

    NumberAnimation on opacity {
        id: fadeInAnimation
        running: false
        to: 1
        duration: 400
        easing.type: Easing.OutCubic
    }
    NumberAnimation on opacity {
        id: fadeOutAnimation
        running: false
        to: 0
        duration: 150
        easing.type: Easing.InCubic
    }

    onRunningChanged: {
        if (running) {
            fadeOutAnimation.stop()
            fadeInAnimation.start()
        }
        else {
            fadeInAnimation.stop()
            fadeOutAnimation.start()
        }
    }
}
