import QtQuick 2.0

Rectangle {
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    color: "#343434"

    GUIButton{
        source_string: "pause-button.png"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 15
        anchors.leftMargin: 15
    }
}
