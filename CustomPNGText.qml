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
    id: customPNGText

    property string textToShow
    property int fontPixelHeight

    property var createdChars: new Array

    color: "transparent"
    property int columnSpacing: 0
    property int rowSpacing: 0.33
    property int spaceWidth: 0.6

    Component {
        id: characterImageComponent
        Image {
            property string character
            height: fontPixelHeight
            width: height * dataModel.pngFontWidthRatio[character]
            fillMode: Image.PreserveAspectFit
            smooth: false
            source: "qrc:/png_chars/" + character + ".png"
        }
    }

    Timer {
        id: customPNGTextObjectSizeChangedTimer
        interval: 50
        running: false
        onTriggered: {
            repositionCharacters()
        }
    }

    onWidthChanged: customPNGTextObjectSizeChangedTimer.restart()
    onHeightChanged: customPNGTextObjectSizeChangedTimer.restart()

    onTextToShowChanged: {
        clearCurrentCharacters()
        for (var i = 0 ; i < textToShow.length ; i++) {
            createdChars.push(
                        characterImageComponent
                        .createObject(customPNGText,
                                      {"character": textToShow[i]}))
        }
        customPNGTextObjectSizeChangedTimer.restart()
    }

    Component.onCompleted: {
        console.log(rows, columns)
        textToShow = "123123123123345469834"
    }

    function clearCurrentCharacters() {
        for (var i = createdChars.length - 1 ; i >= 0 ; i--)
            createdChars[i].destroy()
        createdChars.splice(0, createdChars.length)
    }

    function repositionCharacters() {
        var lines = new Array
        var lineSizes = new Array
        var i, j
        // calculate length of each word
        var words = textToShow.split(" ")
        var wordSizes = new Array
        for (i = 0 ; i < words.length ; i++) {
            wordSizes.push(0)
            for (j = 0 ; j < words[i].length ; j++) {
                wordSizes[wordSizes.length - 1] +=
                        dataModel.pngFontWidthRatio[words[i][j]]
            }
        }
        // find the biggest font size (try different amount of lines)
        var biggestFontSize = 0
        var bestNumberOfLines = 0
        for (i = 1 ; i <= words.length ; i++) {
            // calculate size of the font for each number of lines

        }

        var currentLineLength
        var lineMaxLength = customPNGText.width / height
        for (i = 0 ; i < words.length ; i++) {

        }

        for (i = 0 ; i < createdChars.length ; i++) {

        }
        lines.splice(0, lines.length)
        lineSizes.splice(0, lineSizes.length)
        words.splice(0, words.length)
        wordSizes.splice(0, wordSizes.length)
    }

}
