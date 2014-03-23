import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
    id: gameScreen
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    color: "#343434"
    opacity: 1
    z: 0

    property int _MIDDLE_TUBE_WIDTH: 56
    SoundEffect {
            id: playSound
            source: "ButtonClick2.wav"
        }
    Image {
        id: gameScreen_background
        width: parent.width; height: parent.height
        anchors.centerIn: gameScreen
        source: "game-background.png"
        fillMode: Image.PreserveAspectFit
        z: 0
        visible: true
    }

    Image {
        id: top_tubes
        width: 525; height: 135; z:5
        source: "top_tubes.png"
        fillMode: Image.PreserveAspectFit
        visible: true

        anchors.top: parent.top
        anchors.topMargin: 25
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 - (top_tubes.width/2)

    }


    ConveyorBelt {
        reverseBelt: true
        anchors.right: top_tubes.left
        anchors.rightMargin: -55
        anchors.top: top_tubes.top
        anchors.topMargin: 80
        z:5
    }

    ConveyorBelt {
        reverseBelt: false
        anchors.left: top_tubes.right
        anchors.leftMargin: -55
        anchors.top: top_tubes.top
        anchors.topMargin: 80
        z:5
    }

    Rectangle {
        id: middle_tube
        width: _MIDDLE_TUBE_WIDTH
        height: parent.height - 140
        color: "grey"
        opacity: 0.5
        z:5

        anchors.top: top_tubes.bottom
        anchors.topMargin: - 20
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 - (middle_tube.width/2)
    }

    LeftAnimationGumdrop {
        startDelay: 1989
        z: 2
    }

    /*
    LeftAnimationGumdrop {
        startDelay: 1000
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 2385
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 2785
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 3799
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 3902
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 4007
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 4191
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 4335
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 4535
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 4739
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 4809
        z: 3
    }

    LeftAnimationGumdrop {
        startDelay: 5001
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 5943
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 7215
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 7922
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 8812
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 9532
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 10954
        z: 2
    }
    LeftAnimationGumdrop {
        startDelay: 11911
        z: 3
    }
    LeftAnimationGumdrop {
        startDelay: 13001
        z: 2
    }

    LeftAnimationGumdrop {
        startDelay: 20001
        z: 2
        isStrayPiece: true
    }
    */

    RightAnimationGumdrop {
        startDelay: 1000
        z: 3
    }
    /*
    RightAnimationGumdrop {
        startDelay: 1989
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 2385
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 2785
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 3799
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 3902
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 4007
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 4191
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 4335
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 4535
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 4739
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 4809
        z: 2
    }

    RightAnimationGumdrop {
        startDelay: 5001
        z: 3
    }

    RightAnimationGumdrop {
        startDelay: 5943
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 7215
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 7922
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 8812
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 9532
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 10954
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 11911
        z: 2
    }
    RightAnimationGumdrop {
        startDelay: 13001
        z: 3
    }
    RightAnimationGumdrop {
        startDelay: 24001
        z: 3
        isStrayPiece: true
    }
    */
    Image {
        id: hg_in_bucket
        width: 250; height: 215
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: (parent.height/2) - 75
        source: "hg-bucket.png"
        fillMode: Image.PreserveAspectFit
        z: 5
    }

    GameMenu {
        id: myGameMenu
        state: "INVISIBLE"
        z: 100
    }

    Rectangle {
        id: pauseOpacity
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: "#000000"
        opacity: 0
        z: 85

        Connections{
            target: page
            onPauseOpacity:{
                pauseOpacity.state = "OPAQUE";
            }
            onClearPauseOpacity:{
                pauseOpacity.state = "CLEAR";
            }
        }

        states: [
            State{

                name: "CLEAR"

                PropertyChanges {

                    target: pauseOpacity
                    opacity: 0
                }
            },

            State{

                name: "OPAQUE"

                PropertyChanges {

                    target: pauseOpacity
                    opacity: 0.75
                }
            }

        ]

        transitions: [
            Transition{
                from: "CLEAR"
                to: "OPAQUE"
                NumberAnimation{
                    properties: "opacity"
                    from: 0
                    to: 0.75
                    duration: 300
                }
            },
            Transition{
                from: "OPAQUE"
                to: "CLEAR"
                NumberAnimation{
                    properties: "opacity"
                    from: 0.75
                    to: 0
                    duration: 300
                }
            }

        ]




    }



    GUIButton {
        source_string: "pause-button.png"
        anchors.top: gameScreen.top
        anchors.left: gameScreen.left
        anchors.topMargin: 15
        anchors.leftMargin: 30
        z: 5

        MouseArea {
            anchors.fill: parent
            onPressed: { playSound.play() }
            onClicked: myGameMenu.state = "VISIBLE"
        }
    }
}
