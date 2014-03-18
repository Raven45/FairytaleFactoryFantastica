import QtQuick 2.0

Rectangle{
    id: root
    property string message
    property string button1Text
    property string button2Text
    property bool hideButtons: false

    signal button1Clicked()
    signal button2Clicked()

    width: 600
    height: 200
    border.color: "black"
    border.width: 10
    radius: 10
    state: "INVISIBLE"

    states:[
        State{
            name: "INVISIBLE"
            PropertyChanges {
                target: root
                visible: false
            }
        },
        State{
            name: "VISIBLE"
            PropertyChanges {
                target: root
                visible: true
            }
        }
    ]

    Image {
        id: image1
        source: "steelplate.jpg"
        anchors.centerIn: parent
        anchors.fill: parent
    }

    GenericText{
        text: message
    }

    GenericButton {
        id: button1
        buttonText: button1Text
        visible: !hideButtons
        onClicked:{
            button1Clicked()
        }
    }

    GenericButton {
        id: button2
        buttonText: button2Text
        anchors.rightMargin: 121
        visible: !hideButtons
        onClicked:{
            button2Clicked()
        }
    }
}
