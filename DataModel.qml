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
    id: dataModel
    color: "transparent"


    property int windowLength: appWindow.width + appWindow.height
    property int windowWidth: appWindow.width
    property int windowHeight: appWindow.height

    property var pngFontWidthRatio: new Array

    property bool debugView: false

    Component.onCompleted: {
        pngFontWidthRatio["0"] = 0.7
        pngFontWidthRatio["1"] = 0.7
        pngFontWidthRatio["2"] = 0.7
        pngFontWidthRatio["3"] = 0.7
        pngFontWidthRatio["4"] = 0.7
        pngFontWidthRatio["5"] = 0.7
        pngFontWidthRatio["6"] = 0.7
        pngFontWidthRatio["7"] = 0.7
        pngFontWidthRatio["8"] = 0.7
        pngFontWidthRatio["9"] = 0.7
    }

    function differenceBetweenTwoAngles(rot1, rot2) {
        while (rot1 < 0)
            rot1 += 360;
        rot1 %= 360;
        while (rot2 < 0)
            rot2 += 360;
        rot2 %= 360;

        var res1, res2;
        res1 = rot1 - rot2;
        res2 = rot2 - rot1;
        while (res1 < 0)
            res1 += 360;
        res1 %= 360;
        while (res2 < 0)
            res2 += 360;
        res2 %= 360;

        return Math.min(res1, res2);
    }
}
