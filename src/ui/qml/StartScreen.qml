import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Particles 2.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

Rectangle {
    id: startScreen
    width: parent.width
    height: parent.height
    z: 100
    color: "#00FFFF"
    visible: false

    state: "INVISIBLE"

    SoundEffect {
        id: gateSound
        source: "metal-gate.wav"
    }

    SoundEffect {
        id: wolfSound
        source: "wolf-growl.wav"
    }

    SoundEffect {
        id: buzzerSound
        source: "buzzer.wav"
    }

    SoundEffect {
        id: swooshSound
        source: "swoosh.wav"
    }

    SoundEffect {
        id: scarySound
        source: "scary.wav"
    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: readyToExitGame();
    }

    Image {
        id: main_background
        width: parent.width; height: parent.height; z: 0
        anchors.centerIn: parent
        source: "HomeMenu.png"
        fillMode: Image.PreserveAspectCrop
    }


    Image{
        id: main_factory
        source: "Factory.png"
        anchors.right: parent.right
        anchors.rightMargin: 2
        anchors.top: parent.top
        anchors.topMargin: 100
        z: 1
        height: 165
        width: 240
        fillMode: Image.PreserveAspectFit
    }

    QmlTimer{
        id: gretelBlinkTimer
        duration: 5000
        onTriggered:{
            gretelBlink.visible = true;
            showGretelBlinkTimer.startTimer();

        }
    }

    QmlTimer{
        id: hanselBlinkTimer
        duration: 3800
        onTriggered: {
            hanselBlink.visible = true;
            showHanselBlinkTimer.startTimer();
        }

        QmlTimer{
            id: showGretelBlinkTimer
            duration: 150
            onTriggered:{
                gretelBlink.visible = false;
                gretelBlinkTimer.startTimer();
            }
        }
    }

    QmlTimer{
        id: showHanselBlinkTimer
        duration: 150
        onTriggered: {
            hanselBlink.visible = false;
            hanselBlinkTimer.startTimer();
        }
    }

    Rectangle {
        id: smokeRectangle
        color: "transparent"
        state: "ON"
        anchors.centerIn: parent
        anchors.fill: parent
        z: 20
        states: [
            State{
                name: "ON"
                PropertyChanges { target: fog;  enabled: true }
                PropertyChanges { target: flame;  enabled: true }
                PropertyChanges { target: smoke1; enabled: true }
                PropertyChanges { target: smoke2; enabled: true }
                PropertyChanges { target: flame2;  enabled: true }
                PropertyChanges { target: smoke3; enabled: true }
                PropertyChanges { target: smoke4; enabled: true }
                PropertyChanges { target: thickFog; enabled: false }
                PropertyChanges { target: thickFog2; enabled: false }
            },
            State{
                name: "OFF"
                PropertyChanges { target: fog;  enabled: false }
                PropertyChanges { target: flame;  enabled: false }
                PropertyChanges { target: smoke1; enabled: false }
                PropertyChanges { target: smoke2; enabled: false }
                PropertyChanges { target: flame2;  enabled: false }
                PropertyChanges { target: smoke3; enabled: false }
                PropertyChanges { target: smoke4; enabled: false }
                PropertyChanges { target: thickFog; enabled: false }
                PropertyChanges { target: thickFog2; enabled: false }
            }

        ]


        ParticleSystem {
            id: particle_system
            anchors.fill: parent

            /*Turbulence {
                id: turb
                enabled: true
                height: (parent.height / 2) - 4
                width: parent.width
                //height: 500
                //width: 500
                x: parent. width / 4
                anchors.fill: parent
                strength: -16
                NumberAnimation on strength{from: -32; to: 0; easing.type: Easing.InOutBounce; duration: 1800; loops: -1}
            }*/

            ImageParticle {
                groups: ["fog"]
                source: "qrc:///particleresources/glowdot.png"
                color: "#11111111"
                colorVariation: 0
                opacity: .7

            }

            ImageParticle {
                groups: ["thickFog"]
                source: "qrc:///particleresources/glowdot.png"
                color: "#000000"
                colorVariation: 0
                opacity: 1

            }

            ImageParticle {
                groups: ["smoke", "smoke2"]
                source: "qrc:///particleresources/glowdot.png"
                color: "#DDDDDD"
                colorVariation: 0
            }

            ImageParticle {
                groups: ["flame", "flame2"]
                source: "qrc:///particleresources/glowdot.png"
                color: "#11111111"
                //colorVariation: 0.1
            }


            Emitter {
                id: thickFog
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                height: parent.height
                group: "thickFog"
                z:15
                shape: LineShape{}
                lifeSpan: 5000
                lifeSpanVariation: 400
                emitRate: 25
                size: 800
                endSize: 1200
                sizeVariation: 100
                enabled: false
                acceleration: PointDirection { x: 250; xVariation: 20; y: 0; yVariation: 3}
                velocity: AngleDirection { angle: 0; magnitude: 180; angleVariation: 30; magnitudeVariation: 80 }

                Connections{
                    target: page

                    onGateOpened:{
                        thickFog.enabled = true;
                        thickFog2.enabled = true;
                        flame.enabled = false;
                        flame2.enabled = false;
                        fadeTimer.startTimer();
                        frownTimer.startTimer();
                        if(_SOUND_CHECK_FLAG) gateSound.play();
                    }
                }

                NumberAnimation{
                    id: fadeStartMenu; target: menuFade; properties: "opacity"; to: 1; duration: 1800;
                    onStopped: {
                        thickFog.enabled = false;
                        thickFog2.enabled = false;
                        startScreen.state = "INVISIBLE";
                        startMenu.state = "VISIBLE";

                        musicPlayer.switchAudioFile();
                    }
                }

                QmlTimer{
                    id: frownTimer
                    duration: 360
                    onTriggered: {
                        gretelFrown.visible = true;
                        hanselFrown.visible = true;
                    }
                }

                QmlTimer{
                    id: fadeTimer
                    duration: 1600
                    onTriggered: {
                        fadeStartMenu.start();
                    }
                }


            }

            Emitter {
                id: thickFog2
                anchors.left: parent.right
                anchors.bottom: parent.bottom
                height: parent.height
                group: "thickFog"
                z:20
                shape: LineShape{}
                lifeSpan: 3500
                lifeSpanVariation: 400
                emitRate: 15
                size: 800
                endSize: 1200
                sizeVariation: 100
                enabled: false
                acceleration: PointDirection { x: -30; xVariation: 20; y: 0; yVariation: 3}
                velocity: AngleDirection { angle: 180; magnitude: 160; angleVariation: 30; magnitudeVariation: 80 }
            }

            Emitter {
                id: fog
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                height: parent.height*.75
                group: "fog"
                z:5
                shape: LineShape{}
                lifeSpan: 9500
                lifeSpanVariation: 400
                emitRate: 10
                size: 600
                endSize: 100
                sizeVariation: 300
                acceleration: PointDirection { x: 30; xVariation: 20; y: 5; yVariation: 3}
                velocity: AngleDirection { angle: 0; magnitude: 80; angleVariation: 30; magnitudeVariation: 50 }


            }


            Emitter {
                id: flame
                anchors.bottom: parent.top
                anchors.bottomMargin: -115
                anchors.right: parent.right
                anchors.rightMargin: 50
                group: "flame"
                z: 15
                emitRate: 120
                lifeSpan: 1200
                size: 20
                endSize: 10
                sizeVariation: 10
                acceleration: PointDirection { y: -40 }
                velocity: AngleDirection { angle: 270; magnitude: 20; angleVariation: 100; magnitudeVariation: 5 }
            }
            TrailEmitter {
                id: smoke1
                enabled: true
                width: 500
                height: 500/2
                group: "smoke"
                follow: "flame"
                z: 15
                emitRatePerParticle: 2
                lifeSpan: 3600
                lifeSpanVariation: 400
                size: 16
                endSize: 8
                sizeVariation: 8
                acceleration: PointDirection { y: -10 }
                velocity: AngleDirection { angle: 270; magnitude: 40; angleVariation: 90; magnitudeVariation: 5 }
            }
            TrailEmitter {
                id: smoke2
                enabled: true
                width: 500
                height: 500/2 - 20
                group: "smoke"
                follow: "flame"
                z: 15
                emitRatePerParticle: 1
                lifeSpan: 4800
                size: 36
                endSize: 24
                sizeVariation: 12
                acceleration: PointDirection { y: -20 }
                velocity: AngleDirection { angle: 270; magnitude: 40; angleVariation: 30; magnitudeVariation: 5 }
            }

            Emitter {
                id: flame2
                anchors.bottom: parent.top
                anchors.bottomMargin: -115
                anchors.right: parent.right
                anchors.rightMargin: 150
                group: "flame2"
                z: 15
                emitRate: 120
                lifeSpan: 1200
                size: 20
                endSize: 10
                sizeVariation: 10
                acceleration: PointDirection { y: -40 }
                velocity: AngleDirection { angle: 270; magnitude: 20; angleVariation: 100; magnitudeVariation: 5 }
            }
            TrailEmitter {
                id: smoke3
                enabled: true
                width: 500
                height: 500/2
                group: "smoke2"
                follow: "flame2"
                z: 15
                emitRatePerParticle: 2
                lifeSpan: 3600
                lifeSpanVariation: 400
                size: 16
                endSize: 8
                sizeVariation: 8
                acceleration: PointDirection { y: -10 }
                velocity: AngleDirection { angle: 270; magnitude: 40; angleVariation: 90; magnitudeVariation: 5 }
            }
            TrailEmitter {
                id: smoke4
                enabled: true
                width: 500
                height: 500/2 - 20
                group: "smoke2"
                follow: "flame2"
                z: 15
                emitRatePerParticle: 1
                lifeSpan: 4800
                size: 36
                endSize: 24
                sizeVariation: 12
                acceleration: PointDirection { y: -20 }
                velocity: AngleDirection { angle: 270; magnitude: 40; angleVariation: 30; magnitudeVariation: 5 }
            }

        }

    }

    Image {
        id: main_gate
        source: "Gate.png"
        anchors.right: parent.right
        anchors.rightMargin: 150
        anchors.top: parent.top
        anchors.topMargin: 20
        z: 10
        height: 512
        width: 692
        fillMode: Image.PreserveAspectFit
    }

    Image{
        id: rightWall
        source: "RightWall.png"
        anchors.right: main_gate.left
        anchors.rightMargin: -35
        anchors.bottom: main_gate.bottom
        anchors.bottomMargin: 28
        z: 9
        fillMode: Image.PreserveAspectFit
    }

    Image{
        id: leftWall
        source: "LeftWall.png"
        anchors.left: main_gate.right
        anchors.leftMargin: -75
        anchors.bottom: main_gate.bottom
        anchors.bottomMargin: -17
        z: 10
        fillMode: Image.PreserveAspectFit
    }

    SpriteSequence{
        id: gate_lDoorSprite
        height: 360
        width: 280
        anchors.bottom: main_gate.bottom
        anchors.bottomMargin: 30
        anchors.left: main_gate.left
        anchors.leftMargin: 80
        z: 10
        sprites:[
            Sprite{
                name: "closed_gate"
                source: "left-gate-spritesheet.png"
                frameCount: 1
                frameX: 0
                frameY: 0
                frameDuration: 5000
                frameWidth: 280
                frameHeight: 360
            },
            Sprite{
                name: "opening_gate"
                source: "left-gate-spritesheet.png"
                frameCount: 20
                frameX: 0
                frameY: 0
                frameDuration: 68
                frameWidth: 280
                frameHeight: 360
                to:{
                    "open_gate": 1
                }
            },
            Sprite{
                name: "open_gate"
                source: "left-gate-spritesheet.png"
                frameCount: 1
                frameX: 840
                frameY: 1440
                frameDuration: 100
                frameWidth: 280
                frameHeight: 360
            }

        ]
    }

    Image{
        id: gate_rDoor
        source: "GatePart2.png"
        anchors.bottom: main_gate.bottom
        anchors.bottomMargin: 20
        anchors.right: main_gate.right
        anchors.rightMargin: 130
        z: 9
        height: 360
        width: 280
        fillMode: Image.PreserveAspectFit
    }

    Image{
        id: hansel
        source: "Hansel.png"
        anchors.right: gate_lDoorSprite.right
        anchors.rightMargin: 58
        anchors.bottom: gate_lDoorSprite.bottom
        anchors.bottomMargin: -55
        z: 11
        height: 240
        width: 160
        fillMode: Image.PreserveAspectFit

    }


    Image{
        id: gretel
        source: "Gretel.png"
        anchors.left: hansel.right
        anchors.leftMargin: -15
        anchors.top: gate_lDoorSprite.bottom
        anchors.bottomMargin: -60
        z: 11
        height: 240
        width: 160
        fillMode: Image.PreserveAspectFit


    }


    Image{
        id: gretelFrown
        source: "gretelFrown.png"
        anchors.centerIn: gretel
        z: 12
        height: 240
        width: 160
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    Image{
        id: gretelBlink
        source: "gretelBlink.png"
        anchors.centerIn: gretel
        z: 12
        height: 240
        width: 160
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    Image{
        id: hanselFrown
        source: "hanselFrown2.png"
        anchors.centerIn: hansel
        z: 12
        height: 240
        width: 160
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    Image{
        id: hanselBlink
        source: "hanselBlink2.png"
        anchors.centerIn: hansel
        z: 12
        height: 240
        width: 160
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    Image{
        id: breadcrumbs
        source: "Bread.png"
        anchors.right: gretel.left
        anchors.rightMargin: -25
        anchors.top: gretel.bottom
        anchors.topMargin: -20
        z: 11
    }

    Glow {
       id: hiringSign_glowEffect
       anchors.fill: hiringSign
       radius: 12
       samples: 24
       spread: 0.5
       color: "#ffea00"
       source: hiringSign
       visible: false
       fast: true
       cached: true
       z: hiringSign.z + 1
    }

    Image{
        id: hiringSign
        source: "HiringSign.png"
        anchors.left: main_gate.left
        anchors.leftMargin: -97
        anchors.verticalCenter: main_gate.verticalCenter
        anchors.verticalCenterOffset: 100
        z:19
        scale: .3

        MouseArea {
            id: hiringSign_mouseArea
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                if(hiringSign_glowEffect.visible == false && hiringSign_mouseArea.containsMouse){
                    hiringSign_glowEffect.visible = true;
                }
            }
            onExited: {
                if(hiringSign_glowEffect.visible == true){
                    hiringSign_glowEffect.visible = false;
                }
            }
            onPressed: if(_SOUND_CHECK_FLAG) scarySound.play()
        }
    }

    Image{
        id: sign
        source: "Sign.png"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -150
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -185
        z: 16
        scale: .9

        Glow {
           id: enterButton_glowEffect
           anchors.fill: enterButton_image
           radius: 16
           samples: 24
           spread: 0.8
           color: "#941a1a"
           source: enterButton_image
           visible: false
           fast: true
           cached: true
        }

        Image{
            id: enterButton_image
            source: "EnterButton.png"
            z: 50
            anchors.left: parent.left
            anchors.leftMargin: 85
            anchors.top: parent.top
            anchors.topMargin: 90

            MouseArea {
                id: enterButton_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(enterButton_glowEffect.visible == false && enterButton_mouseArea.containsMouse){
                        enterButton_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(enterButton_glowEffect.visible == true){
                        enterButton_glowEffect.visible = false;
                    }
                }
                onPressed:{
                    hiringSign_mouseArea.hoverEnabled = false;
                    if(_SOUND_CHECK_FLAG) buzzerSound.play()
                }
                onClicked:{
                    gate_lDoorSprite.jumpTo("opening_gate");
                    gateOpened();
                }
            }
        }

        Glow {
           id: exitLever_glowEffect
           anchors.fill: leverHandle
           radius: 16
           samples: 24
           spread: 0.8
           color: "#941a1a"
           source: leverHandle
           visible: false
           fast: true
           cached: true
        }

        Image{
            id: exitLever
            source: "ExitLever.png"
            z: 17
            x: 179
            y: 65

            PropertyAnimation{
                id: moveLever
                target: exitLever
                properties: "y"
                to: 115
                duration: 700
            }

            MouseArea {
                id: exitLever_mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(exitLever_glowEffect.visible == false && exitLever_mouseArea.containsMouse){
                        exitLever_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(exitLever_glowEffect.visible == true){
                        exitLever_glowEffect.visible = false;
                    }
                }
                onPressed: if(_SOUND_CHECK_FLAG) swooshSound.play()
                onClicked: {
                    moveLever.start();
                    exitTimer.start();
                    //readyToExitGame();
                }
            }
            Item{
                Timer{
                    id: exitTimer
                    interval: 710
                    running: false
                    onTriggered: readyToExitGame()
                }
            }

        }

        Image{
            id: leverHandle
            source: "Lever.png"
            z: 17
            anchors.left: enterButton_image.right
            anchors.leftMargin: -10
            anchors.top: enterButton_image.top
            anchors.topMargin: -20
        }
    }


    Image{
        id:  footprints
        source: "FootPrints.png"
        anchors.left: parent.left
        anchors.leftMargin: -20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -30
        z: 5
    }

    Item {
        id: wolf
        width: wolf_image.width; height: wolf_image.height
        z: 13
        anchors.bottom: footprints.top
        anchors.left: footprints.right
        anchors.leftMargin: -50

        Glow {
           id: wolf_glowEffect
           anchors.fill: wolf_image
           radius: 24
           samples: 12
           spread: 0.4
           color: "#190c22"
           source: wolf_image
           visible: false
           fast: true
           cached: true
        }

        Image{
            id: wolf_image
            source: "Wolf.png"
            z: 13

            MouseArea {
                id: wolf_mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onPressed: if(_SOUND_CHECK_FLAG) wolfSound.play()
                onEntered: {
                    if(wolf_glowEffect.visible == false && wolf_mouseArea.containsMouse){
                        wolf_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(wolf_glowEffect.visible == true){
                        wolf_glowEffect.visible = false;
                    }
                }
            }
        }
    }

    Image{
        id: treeLayer1
        source: "Tree5.png"
        anchors.left: parent.left
        anchors.leftMargin: 2
        anchors.top: parent.top
        anchors.topMargin: 40
        z: 1
    }

    Image{
        id: treeLayer2
        source: "Tree5.png"
        anchors.left: treeLayer1.right
        anchors.top: parent.top
        anchors.topMargin: 40
        z: 1
    }

    Image{
        id: treeLayer3
        source: "Tree1.png"
        anchors.left: parent.left
        anchors.leftMargin: -150
        anchors.bottom: parent.bottom
        z: 15
    }
    Image{
        id: treeLayer4
        source: "Tree2.png"
        anchors.left: parent.left
        anchors.leftMargin: -200
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 200
        z: 14
    }

    Image{
        id: treeLayer5
        source: "Tree4.png"
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -220
        z: 7
    }
    Image{
        id: treeLayer6
        source: "Tree7.png"
        anchors.left: treeLayer5.right
        anchors.leftMargin: -100
        anchors.bottom: treeLayer5.bottom
        anchors.bottomMargin: -130
        z: 10
        visible: false
    }


    Image{
        id: treeLayer7
        source: "Tree1.png"
        anchors.right: parent.right
        anchors.rightMargin: -150
        anchors.bottom: parent.bottom
        z: 15
    }
    Image{
        id: treeLayer8
        source: "Tree2.png"
        anchors.right: parent.right
        anchors.rightMargin: -200
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 200
        z: 14
    }

    Witch {
        id: startMenu_witch
        z: 2
    }

    states: [
        State{
            name: "VISIBLE"
            PropertyChanges { target: smokeRectangle; state: "ON" }
            PropertyChanges { target: startMenu_witch;  state: "ON" }
            PropertyChanges { target: menuFade; opacity: 0; visible: true; }
            PropertyChanges { target: gretelFrown; visible: false }
            PropertyChanges { target: hanselFrown; visible: false }
            PropertyChanges { target: startScreen; visible: true }
            PropertyChanges { target: gretelBlink; visible: false }
            PropertyChanges { target: hanselBlink; visible: false }
            PropertyChanges { target: gretelBlinkTimer; duration: 5000 }
            PropertyChanges { target: hanselBlinkTimer; duration: 3800 }
            StateChangeScript { script: hanselBlinkTimer.startTimer() }
            StateChangeScript { script: gretelBlinkTimer.startTimer() }
        },
        State{
            name: "INVISIBLE"
            PropertyChanges { target: smokeRectangle; state: "OFF" }
            PropertyChanges { target: startMenu_witch;  state: "OFF" }
            PropertyChanges { target: menuFade; opacity: 0; visible: false; }
            PropertyChanges { target: startScreen; visible: false }
            PropertyChanges { target: gretelFrown; visible: false }
            PropertyChanges { target: hanselFrown; visible: false }
            PropertyChanges { target: gretelBlink; visible: false }
            PropertyChanges { target: hanselBlink; visible: false }
            PropertyChanges { target: gretelBlinkTimer; duration: 0 }
            PropertyChanges { target: hanselBlinkTimer; duration: 0 }
        }

    ]


}
