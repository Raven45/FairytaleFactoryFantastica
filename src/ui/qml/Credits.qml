import QtQuick 2.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

Rectangle {
    id: creditsScreen

    visible: false
    color:"transparent"
    states: [
        State{
            name: "SHOW_CREDITS"
            PropertyChanges { target: creditsScreen; visible: true }
        },
        State{
            name: "HIDE_CREDITS"
            PropertyChanges { target: creditsScreen; visible: false }
        }
    ]

    MouseArea {
        anchors.fill: parent
        onPressed: { playSound.play() }
        onClicked: {
            credits.state = "HIDE_CREDITS";
        }
    }
    Text {
        id: infoCredits
        width: parent.width; height: parent.height;
        z: parent.z + 1
        text:
"Sound effects:

Mark DiAngelo
http://soundbible.com/1810-Wind.html

Music:

Monkeys Spinning Monkeys
Oppressive Gloom

Art assets:
"
        font.pointSize: 15
        font.bold: true
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        color: "#9DEB9B"
        anchors.fill: creditsScreen
        //anchors.verticalCenterOffset: 300
        visible: true
    }

    Image {
        id: background
        source: "steelplate.jpg"
        visible: true
        z: parent.z - 1
        width: credits.width; height: credits.height;
        anchors.fill: credits
    }
    Image {
        id: exitCredits
        source: "exitButton.png"
        width: 100; height: 100;
        z: parent.z + 1
        anchors.left: creditsScreen.left
        anchors.leftMargin: 20
        anchors.bottom: creditsScreen.bottom
        anchors.bottomMargin: 20
        visible: true
        MouseArea {
            anchors.fill: parent
            onClicked:{
                creditsScreen.state = "HIDE_CREDITS"
            }
        }
    }
}
