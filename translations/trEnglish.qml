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

Item {
    property string bestScore: "Best score: "
    property string start: "Start!"
    property string back: "Back"
    property string resume: "Resume"
    property string restart: "Restart"
    property string quit: "Quit"
    property string gameOver: "Game Over!"
    property string yourScore: "Your score:"
    property string playAgain: "Play again"
    property string score: "Score: "
    property string time: "Time: "


    property string purr: "Purr!"
    property string target: "Target:"
    property string current: "Current:"
    property string choose: "Choose "

    property var gameNames: [
        "Tap 'Em Out!",
        "Roll The Cat!",
        "Juggle!",
        "Avoid Shurikens!",
        "Mix Colors!"
    ]
}
