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
    id: movingTileBackground

    color: "transparent"


    // angle is as on mathematical surface
    // 0 means right
    // PI / 2 means up
    // PI means left
    // PI * 3 / 2 means down
    property double angle
    // velocity is pixels over miliseconds
    property double velocity
    property string tileSource
    // change to start/stop animation
    property bool animationRunning: true


    property int tileWidth: 1
    property int tileHeight: 1

    property double viewNewX: 0
    property double viewNewY: 0


    Image {
        id: readWidthHeightImage
        source: tileSource
        visible: false
        onStatusChanged: {
            if (status == Image.Ready) {
                tileWidth = width
                tileHeight = height
            }
        }
    }

    Image {
        id: backgroundImage
        source: tileSource
        fillMode: Image.Tile
        property int howMuchTilesFillScreenHorizontally:
            Math.ceil((movingTileBackground.width / tileWidth))
        property int howMuchTilesFillScreenVertically:
            Math.ceil((movingTileBackground.height / tileHeight))
        width: ( howMuchTilesFillScreenHorizontally + 1 ) * tileWidth
        height: ( howMuchTilesFillScreenVertically + 1 ) * tileHeight

        property double almostNewX: viewNewX % tileWidth
        property double almostNewY: viewNewY % tileHeight
        x: ( almostNewX > 0 ? almostNewX - tileWidth : almostNewX )
        y: ( almostNewY > 0 ? almostNewY - tileHeight : almostNewY )
    }


    Timer {
        id: updatePositionTimer
        interval: 16
        running: true
        repeat: true
        property var lastDate: new Date
        onTriggered: {
            var time = 16
            var distance = time * velocity
            if (distance > 1) {
                viewNewX += Math.cos(angle) * distance * (-1)
                viewNewY += Math.sin(angle) * distance * (-1)
            }
        }
    }

    onAnimationRunningChanged: {
        if (animationRunning) {
            updatePositionTimer.lastDate = new Date
            updatePositionTimer.start()
        }
        else
            updatePositionTimer.stop()
    }

}
