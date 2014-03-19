import QtQuick 2.0

Rectangle {
    id: gameScreen
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    color: "#343434"
    opacity: 1
    z: 0

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
        width: 525; height: 135; z: 1
        source: "top_tubes.png"
        fillMode: Image.PreserveAspectFit
        visible: true

        anchors.top: parent.top
        anchors.topMargin: 25
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 - (top_tubes.width/2)
    }

    Rectangle {
        id: middle_tube
        width: 56
        height: parent.height - 140
        color: "grey"
        opacity: 0.5
        z:0

        anchors.top: top_tubes.bottom
        anchors.topMargin: - 20
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2 - (middle_tube.width/2)
    }

    Image {
        id: small_gumdrop
        width: 100; height: 100; z: 1
        scale: 0.65
        x: parent.width/2 - (small_gumdrop.width/2)
        y: parent.height + small_gumdrop.height
        source: "teal-gumdrop.png"
    }

    ParallelAnimation{
        id: tube_animation
        running: true
        loops: Animation.Infinite

        RotationAnimation {
            running: true
            loops: Animation.Infinite
            target: small_gumdrop
            duration: 900
            from: 0
            to: 360
        }


        SequentialAnimation{

            running: true
            loops: Animation.Infinite

            PropertyAnimation {
                target: small_gumdrop;
                property: "y";
                easing.type: Easing.InExpo
                from: 1000;
                to: 40;
                duration: 1800;
            }
            PropertyAnimation {
                target: small_gumdrop;
                property: "x";
                easing.type: Easing.InExpo;
                from: 670;
                to: 300;
                duration: 1000;
            }
            PropertyAnimation {
                target: small_gumdrop;
                property: "x";
                easing.type: Easing.InExpo;
                from: 300;
                to: 670;
                duration: 1000;
            }
            PropertyAnimation {
                target: small_gumdrop;
                property: "y";
                easing.type: Easing.InExpo
                from: 40;
                to: 1000;
                duration: 1800;
            }
        }
    }

    Image {
        id: hg_in_bucket
        width: 250; height: 215
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: (parent.height/2) - 75
        source: "hg-bucket.png"
        fillMode: Image.PreserveAspectFit
        z: 1
    }

    GameMenu {
        id: myGameMenu
        state: "INVISIBLE"
        z: 2
    }

    Rectangle {
        id: pauseOpacity
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: "#000000"
        opacity: 0
        z: 1

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
        z: 1

        MouseArea {
            anchors.fill: parent
            onClicked: myGameMenu.state = "VISIBLE"
        }
    }
}
