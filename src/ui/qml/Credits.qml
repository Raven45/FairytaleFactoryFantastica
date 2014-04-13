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

            PropertyChanges {
                target: infoCredits
                color: "#9beb99"
            }
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
"


Music:

Monkeys Spinning Monkeys - Kevin MacLeod (incompetech.com)
Licensed under Creative Commons: By Attribution 3.0
http://creativecommons.org/licenses/by/3.0/

Oppressive Gloom - Kevin MacLeod (incompetech.com)
Licensed under Creative Commons: By Attribution 3.0
http://creativecommons.org/licenses/by/3.0/



Sound effects:

two tone; science_fiction_steampunk_gear_wind;
multimedia_button_click_029;
http://www.freesfx.co.uk

114588__herbertboland__bigdrum1.wav: Herbert Boland / www.freesound.org
114591__herbertboland__bigdrum4.wav: Herbert Boland / www.freesound.org

Mark DiAngelo - http://soundbible.com/1810-Wind.html
Licensed under Creative Commons: By Attribution 3.0
Stephan - http://soundbible.com/1352-Large-Metal-Rusty-Door.html
Licensed under Creative Commons: By Attribution 3.0
Mike Koenig - http://soundbible.com/1291-Dog-Growl.html
Licensed under Creative Commons: By Attribution 3.0
Mike Koenig - http://soundbible.com/1129-Maniacal-Witches-Laugh.html
Licensed under Creative Commons: By Attribution 3.0
Mike Koenig - http://soundbible.com/1359-Small-Fireball.html
Licensed under Creative Commons: By Attribution 3.0
nofeedbak - http://soundbible.com/1495-Basketball-Buzzer.html
Licensed under Creative Commons: By Attribution 3.0
man - http://soundbible.com/682-Swoosh-1.html
Licensed under Creative Commons: By Attribution 3.0
Mike Koenig - http://soundbible.com/1832-Climactic-Suspense.html
Licensed under Creative Commons: By Attribution 3.0
Titus Calen - http://soundbible.com/1814-Scary.html
Licensed under Creative Commons: By Attribution 3.0"


        font.pointSize: 10
        font.bold: true
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        color: "#9DEB9B"
        anchors.centerIn: creditsScreen
//        anchors.horizontalCenterOffset: 50
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
