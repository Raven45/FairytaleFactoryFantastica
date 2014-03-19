import QtQuick 2.0

Rectangle{
    width:102
    height:52
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 10
    anchors.right: parent.right
    anchors.rightMargin: 10
    color: "transparent"

    property string buttonText
    signal clicked()

    GenericText{
        text: buttonText
        font.pointSize: 12
        color: "#E9E8FF"
    }
    Rectangle{
        id: darkBlueBackground
        z: parent.z
        color: "#222480"
        visible: false
        width: 96
        height: 46
        anchors.centerIn: parent
    }

    MouseArea{
        anchors.fill: parent

        hoverEnabled: true
        onEntered: {
            darkBlueBackground.visible = true;
        }
        onExited:{
            darkBlueBackground.visible = false;
        }

        onClicked:{
            parent.clicked();
        }
    }

    Image{
        z: parent.z + 1
        width:parent.width
        height:parent.height

        source: "blackbuttonsmall.png"
        anchors.centerIn: parent
    }
}
