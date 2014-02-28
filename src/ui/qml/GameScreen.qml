import QtQuick 2.0

Rectangle {
    id: gameScreen
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    color: "#343434"

    GameMenu {
        id: myGameMenu
        state: "INVISIBLE"
        z: 2
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
