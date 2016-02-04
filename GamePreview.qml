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
    id: gamePreview
    source: "qrc:/assets/images/game_preview_screen.png"
    fillMode: Image.PreserveAspectFit

    property int gameNumber: -1
    property int currentFrame: 0
    property int numberOfFrames: 4

    property double frameMargins:
        Math.min(Math.floor(paintedWidth / 18),
                 Math.floor(paintedHeight / 11)) - 1
    property double frameWidth: paintedWidth - frameMargins * 2
    property double frameHeight: paintedHeight - frameMargins * 2

    onGameNumberChanged: {
        frame1.source = "qrc:/assets/game_previews/" + gameNumber + "a.png"
        frame2.source = "qrc:/assets/game_previews/" + gameNumber + "b.png"
        frame3.source = "qrc:/assets/game_previews/" + gameNumber + "c.png"
        frame4.source = "qrc:/assets/game_previews/" + gameNumber + "d.png"
        currentFrame = 0
        changeFrameTimer.restart()
    }

    Image {
        id: frame1
        anchors.centerIn: parent
        width: frameWidth
        height: frameHeight
        visible: (currentFrame == 0 ? true : false)
        onStatusChanged: {
            if (status == Image.Error || Image.Null)
                source = "qrc:/assets/game_previews/a.png"
        }
    }
    Image {
        id: frame2
        anchors.centerIn: parent
        width: frameWidth
        height: frameHeight
        visible: (currentFrame == 1 ? true : false)
        onStatusChanged: {
            if (status == Image.Error || Image.Null)
                source = "qrc:/assets/game_previews/b.png"
        }
    }
    Image {
        id: frame3
        anchors.centerIn: parent
        width: frameWidth
        height: frameHeight
        visible: (currentFrame == 2 ? true : false)
        onStatusChanged: {
            if (status == Image.Error || Image.Null)
                source = "qrc:/assets/game_previews/c.png"
        }
    }
    Image {
        id: frame4
        anchors.centerIn: parent
        width: frameWidth
        height: frameHeight
        visible: (currentFrame == 3 ? true : false)
        onStatusChanged: {
            if (status == Image.Error || Image.Null)
                source = "qrc:/assets/game_previews/d.png"
        }
    }

    Timer {
        id: changeFrameTimer
        interval: 400
        running: true
        repeat: true
        onTriggered: {
            currentFrame = (currentFrame + 1) % numberOfFrames
        }
    }
}
