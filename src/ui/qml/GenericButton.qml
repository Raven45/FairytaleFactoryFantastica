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
    }

    MouseArea{
        anchors.fill: parent
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
