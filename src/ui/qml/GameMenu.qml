import QtQuick 2.0

Rectangle {
    id: gameMenu
    anchors.left: parent.left
    width: 250; height: parent.height

    state: "VISIBLE"

    Image {
        width: parent.width; height: parent.height
        source: "ingame-menu.png"
        anchors.centerIn: parent
    }

    states: [
        State{
            name: "INVISIBLE"
            PropertyChanges {
                target: gameMenu
                anchors.leftMargin: -width
            }

        },
        State{
            name: "VISIBLE"
            PropertyChanges {
                target: gameMenu
                anchors.leftMargin: 0
            }
        }
    ]
}
