/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Window 2.1

//! [splash-properties]
Rectangle {
    id: introScreen
    width: parent.width; height: parent.height
    color: "#FF0000"
    visible: false
    anchors.fill: parent
    z:100

    property int timeoutInterval: 10000
    signal timeout


    states: [
        State{
            name: "VISIBLE"
            PropertyChanges { target: introKeySkip; focus: true }
            PropertyChanges{target: escKeyQuit; focus: false}
            PropertyChanges{target: introScreen; visible: true}


        },
        State{
            name: "INVISIBLE"
            PropertyChanges{target: introKeySkip; focus: false}
            PropertyChanges{target: escKeyQuit; focus: true}
            PropertyChanges{target: introScreen; visible: false}

        }
    ]

    Timer {
        id: introTimer
        interval: 10000; running: false; repeat: false
        onTriggered: {
            introTimer.timeout();
            introScreen.state = "INVISIBLE";
            startScreen.state = "VISIBLE";
        }
    }

    Text{
        anchors.horizontalCenter: introScreen.horizontalCenter
        anchors.bottom: introScreen.bottom
        anchors.bottomMargin: 10
        font.pointSize: 14
        color: '#6B6B6B'
        text: '(Spacebar to Skip)'
        z: parent.z + 1
    }

    Item{
        id: introKeySkip
        anchors.fill: parent
        focus: true

        Keys.onSpacePressed: {
            introTimer.stop();
            introScreen.state = "INVISIBLE";
            startScreen.state = "VISIBLE";
        }
    }




    Item {
        id: escKeyQuit
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: readyToExitGame();
    }

}


