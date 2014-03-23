import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Particles 2.0

Rectangle {

    id: startMenu
    width: parent.width
    height: parent.height
    z: 100
    color: "#00FFFF"
    visible: false

    state: "INVISIBLE"

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


//    Smoke {
//        id: startMenu_smoke1
//        anchors.bottom: main_factory.top
//        anchors.bottomMargin: -47
//        anchors.left: main_factory.left
//        anchors.leftMargin: 40
//    }

//    Smoke {
//        id: startMenu_smoke2
//        anchors.bottom: main_factory.top
//        anchors.bottomMargin: -50
//        anchors.right: main_factory.right
//    }






    Rectangle {
        id: smokeRectangle
        color: "transparent"
        state: "ON"
        anchors.centerIn: parent
        anchors.fill: parent
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
                groups: ["smoke", "smoke2"]
                source: "qrc:///particleresources/glowdot.png"
                color: "#11111111"
                colorVariation: 0
            }

            ImageParticle {
                groups: ["flame", "flame2"]
                source: "qrc:///particleresources/glowdot.png"
                color: "#11111111"
                //colorVariation: 0.1
            }


            Emitter {
                id: fog
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                height: parent.height*.8
                group: "fog"
                z:15
                shape: LineShape
                lifeSpan: 8500
                lifeSpanVariation: 400
                emitRate: 10
                size: 600
                endSize: 100
                sizeVariation: 300
                acceleration: PointDirection { x: 30; xVariation: 20; y: 5; yVariation: 3}
                velocity: AngleDirection { angle: 0; magnitude: 90; angleVariation: 30; magnitudeVariation: 50 }
            }


            Emitter {
                id: flame
                anchors.bottom: parent.top
                anchors.bottomMargin: -115
                anchors.right: parent.right
                anchors.rightMargin: 50
                group: "flame"

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

    Image{
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
        id: gate_lDoor
        source: "GatePart1.png"
        anchors.bottom: main_gate.bottom
        anchors.bottomMargin: 30
        anchors.left: main_gate.left
        anchors.leftMargin: 80
        z: 10
        height: 360
        width: 280
        fillMode: Image.PreserveAspectFit
    }

    Image{
        id: hansel
        source: "Hansel.png"
        anchors.right: gate_lDoor.right
        anchors.rightMargin: 58
        anchors.bottom: gate_lDoor.bottom
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
        anchors.top: gate_lDoor.bottom
        anchors.bottomMargin: -60
        z: 11
        height: 240
        width: 160
        fillMode: Image.PreserveAspectFit

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

    Image{
        id: sign
        source: "Sign.png"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -130
        z: 16
        width: 320
        height: 400

    }


    Image{
        id:  footprints
        source: "FootPrints.png"
        anchors.left: parent.left
        anchors.leftMargin: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        z: 5
    }

    Image{
        id: wolf
        source: "Wolf.png"
        anchors.left: footprints.right
        anchors.leftMargin: -50
        anchors.bottom: footprints.top
        z: 13
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
        anchors.verticalCenterOffset: -150
        z: 11
    }
    Image{
        id: treeLayer6
        source: "Tree7.png"
        anchors.left: treeLayer5.right
        anchors.leftMargin: -100
        anchors.bottom: treeLayer5.bottom
        z: 12
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
            //PropertyChanges { target: startMenu_smoke1; state: "ON" }
            //PropertyChanges { target: startMenu_smoke2; state: "ON" }
            PropertyChanges { target: startMenu_witch;  state: "ON" }
            PropertyChanges { target: startMenu; visible: true }
        },
        State{
            name: "INVISIBLE"
            //PropertyChanges { target: startMenu_smoke1; state: "OFF" }
            //PropertyChanges { target: startMenu_smoke2; state: "OFF" }
            PropertyChanges { target: startMenu_witch;  state: "OFF" }
            PropertyChanges { target: startMenu; visible: false }
        }

    ]
    /*

    TextArea{
        id: playerNameBox
        width: 100
        height: 25
        text: "enter a name"
        anchors.top: parent.top
        anchors.topMargin: parent.height/2 + 135
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 + 90
    }

    GUIButton {
        id: startMenu_startOnePlayer
        source_string: "singleplayer-button.png"
        anchors.top: parent.top
        anchors.topMargin: parent.height/2
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 - 150
        z: 3

        MouseArea {
            anchors.fill: parent

            onClicked: {

                if( !piecesHaveStartedAnimating ){
                    startPieceAnimations();
                    piecesHaveStartedAnimating = true;

                }

                sendPlayerName( playerNameBox.text );
                startMenu.state = "INVISIBLE"
                isNetworkGame = false;
                pentagoBoard.state = "UNLOCKED";
                clearBoard();
                readyToStartOnePersonPlay();
            }
        }
    }

    GUIButton {
        id: startMenu_startNetworkPlay
        source_string: "network-button.png"
        anchors.top: parent.top
        anchors.topMargin: parent.height/2 + 100
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2
        z: 3

        MouseArea {
            anchors.fill: parent

            onClicked: {

                if( !piecesHaveStartedAnimating ){
                    startPieceAnimations();
                    piecesHaveStartedAnimating = true;

                }

                sendPlayerName( playerNameBox.text );
                networkLobby.state ="VISIBLE"
                isNetworkGame = true;
                clearBoard();
                enterNetworkLobby();
            }
        }
    }

    GUIButton {

        property int buttonColor

        id: colorSelection
        source_string: "purp-button.png"
        anchors.top: parent.top
        anchors.topMargin: parent.height/2
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2
        z: 3

        state: "BLACK"
        buttonColor: 1

        states: [
            State{
                name: "WHITE"
                PropertyChanges{ target: colorSelection; buttonColor: 0 }
            },
            State{
                name: "BLACK"
                PropertyChanges{ target: colorSelection; buttonColor: 1 }
            }
        ]

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(colorSelection.state == "BLACK")
                {
                    colorSelection.source_string = "teal-button.png"
                    colorSelection.state = "WHITE"
                    page.guiPlayerIsWhite = true;
                    changeGuiPlayerColor(colorSelection.buttonColor);
                }
                else
                {
                    colorSelection.source_string = "purp-button.png"
                    colorSelection.state = "BLACK"
                    page.guiPlayerIsWhite = false;
                    changeGuiPlayerColor(colorSelection.buttonColor);
                }
            }
        }
    }

    GUIButton {
        id: startMenu_soundButton
        source_string: "sound-button.png"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ((parent.height - 30)/4) - 30
        anchors.left: parent.left
        anchors.leftMargin: 30
        z: 3

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (startMenu_soundButton.source_string === "sound-button.png") {
                    startMenu_soundButton.source_string = "nosound-button.png"
                } else {
                    startMenu_soundButton.source_string = "sound-button.png"
                }
                changeSoundState();
            }
        }
    }

    GUIButton {
        id: startMenu_leaveGame
        source_string: "leave-button.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 15
        anchors.leftMargin: 30
        z: 3

        MouseArea {
            anchors.fill: parent

            onClicked: {
                readyToExitGame()
            }
        }
    }
    */

}
