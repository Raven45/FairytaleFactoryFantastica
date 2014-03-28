import QtQuick 2.0
Item {
    id: helpScreen
    visible: false

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

    Image {
        id: image1
        width: 100; height: 100; z: parent.z+1

        source: "exitButton.png"
        anchors.centerIn: parent
        MouseArea{
            anchors.fill: image1;
            onClicked: {
                ;
            }
        }
    }
}
