import QtQuick 2.0
Rectangle {
    id: helpScreen

    visible: false
    color:"transparent"
    states: [
        State{
            name: "SHOW_HELP"
            PropertyChanges { target: helpScreen; visible: true }
        },
        State{
            name: "HIDE_HELP"
            PropertyChanges { target: helpScreen; visible: false }
        }
    ]

    MouseArea {
        anchors.fill: parent
        onPressed: { playSound.play()
            console.log("played sound")}
        onClicked: {
            help.state = "HIDE_HELP";
        }
    }

    Image {
        id: image1
        width: 100; height: 100; z: parent.z+1

        source: "exitButton.png"
        anchors.centerIn: helpScreen
        MouseArea{
            anchors.fill: image1;
            onClicked: {

            }
        }
    }
}
