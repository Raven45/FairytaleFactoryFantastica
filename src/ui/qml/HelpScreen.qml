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

        visible: true
        source: "exitButton.png"
        anchors.centerIn: helpScreen
        MouseArea{
            anchors.fill: image1;
            onPressed: { playSound.play()
                console.log("played sound")}
            onClicked: {
                image1.visible = false;
                step1.visible = true;
            }
        }
    }
    Image {
        id: step1
        width: 700; height: 700; z: parent.z+1

        visible: false
        source: "step1.png"
        anchors.centerIn: helpScreen
        MouseArea{
            anchors.fill: step1;
            onClicked: {
                step1.visible = false;
                step2.visible = true;
            }
        }
    }
    Image {
        id: step2
        width: 700; height: 700; z: parent.z+1

        visible: false
        source: "step2.png"
        anchors.centerIn: helpScreen
        MouseArea{
            anchors.fill: step2;
            onClicked: {
                step2.visible = false;
                step3.visible = true;
            }
        }
    }
    Image {
        id: step3
        width: 700; height: 700; z: parent.z+1

        visible: false
        source: "step3.png"
        anchors.centerIn: helpScreen
        MouseArea{
            anchors.fill: step3;
            onClicked: {
                step3.visible = false;
                step1.visible = true;
            }
        }
    }
}
