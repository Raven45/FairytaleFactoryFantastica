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
    id: splash
    width: parent.width; height: parent.height
    visible: false
    anchors.fill: parent
    z:100

    property int timeoutInterval: 3500
    signal timeout
//! [splash-properties]
//! [screen-properties]
  //  x: (Screen.width - splashImage.width) / 2
    //y: (Screen.height - splashImage.height) / 2

//! [screen-properties]

    Image {
        id: muffinMan
        width: 300
        height: 300
        source: "MuffinMan.png"
        x: 550
        y: 200


        SequentialAnimation{
            id: muffinManAnimation
            running: false

            PropertyAnimation {
                target: muffinMan;
                property: "y";
                easing.type: Easing.InBounce
                to: 20;
                duration: 1250;
            }
            ScriptAction{ script: muffinMan.z = 200; }
            PropertyAnimation {
                target: muffinMan;
                property: "y";
                easing.type: Easing.InExpo;
                to: 200;
                duration: 300;
            }

        }

        Connections{
            target: page
            onLoad:{
                muffinManAnimation.start();
                splashTimer.start();

            }
        }

     }

    Image {
        id: splashImage
        source: "MuffinLogo.png"
        width: 700; height: 700
        anchors.centerIn: splash

    }



    //! [timer]
    Timer {
        id: splashTimer
        interval: timeoutInterval; running: false; repeat: false
        onTriggered: {
            visible = false
            splash.timeout()
            startScreen.state = "VISIBLE";
            muffinManAnimation.running = false;
        }
    }
    //! [timer]


    Keys.onPressed: {
            if (event.key === Qt.Key_Space) {
                event.accepted = true;
                splashTimer.stop();
                splash.visible = false;
                startScreen.state = "VISIBLE";
            }
    }

}
