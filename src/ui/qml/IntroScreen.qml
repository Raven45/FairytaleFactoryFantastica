import QtQuick 2.0
import QtQuick.Window 2.1

//! [splash-properties]
Rectangle {
    id: introScreen
    width: parent.width; height: parent.height
    visible: false
    anchors.fill: parent
    z:100

    //property int timeoutInterval: 10000
    //signal timeout
function getRandomNumber(){
    var number = rand();
    while (number > 1800 || number < 300)
    {
        number = rand();
    }
    return number;
}

    states: [
        State{
            name: "VISIBLE"
            PropertyChanges { target: introKeySkip; focus: true }
            PropertyChanges{target: escKeyQuit; focus: false}
            PropertyChanges{target: introScreen; visible: true}
            PropertyChanges{target: introTimer; running: true}
            PropertyChanges{target: lightsOffTimer; running: true}
        },
        State{
            name: "INVISIBLE"
            PropertyChanges{target: introKeySkip; focus: false}
            PropertyChanges{target: escKeyQuit; focus: true}
            PropertyChanges{target: introScreen; visible: false}
            PropertyChanges{target: introTimer; running: false}
            PropertyChanges{target: lightsOffTimer; running: false}
            PropertyChanges{target: screenOnTimer; running: false}
            PropertyChanges{target: flickerTimer; running: false}
            PropertyChanges{target: bouncingFilmTimer; running: false}


        }
    ]

    Image{
        id: background
        source: "Background.png"
        z: 1
        anchors.bottom: parent.bottom
    }

    /*Image{
        id: topBackground
        source: "introBackground.png"
        z: 2
    }*/

    Image{
        id: screen
        source: "Screen.png"
        height: 860*.9
        width: 1440*.9
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        z:10
    }

    Image{
        id: projector
        source: "Projector.png"
        height: 600*.4
        width: 900*.4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -300
        z:25

        Image{
            id: spinningProjectorWheel
            source: "Nob.png"
            height: 400*.4
            width: 400*.4
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 10
            z:26
        }
    }

    Image{
        id: film
        source: "Film.png"
        height: 100
        width: 100*.8
        x: 450
        y: 740
        //anchors.right: spinningProjectorWheel.right
        //anchors.rightMargin: -20
        //anchors.verticalCenter: spinningProjectorWheel.verticalCenter
        z:27
        visible: true
        opacity: 0

    }

    SequentialAnimation{
        id: filmBounceAnimation
        ParallelAnimation{
            NumberAnimation { target: film; property: "opacity"; from: 0; to: 100; duration: 600; easing.type: Easing.InBack }
            NumberAnimation { target: film; property: "y"; from: film.y; to: film.y-25; duration: 500; easing.type: Easing.InBack }
            RotationAnimation{
                target: spinningProjectorWheel;
                duration: 500;
                direction: RotationAnimation.Clockwise;
                from: 0;
                to: 20
            }
        }
        ParallelAnimation{
            NumberAnimation { target: film; property: "opacity"; from: 100; to: 0; duration: 600; easing.type: Easing.OutBack }
            NumberAnimation { target: film; property: "y"; from: film.y-25; to: film.y; duration: 500; easing.type: Easing.OutBack }
            RotationAnimation{
                target: spinningProjectorWheel;
                duration: 500;
                direction: RotationAnimation.Clockwise;
                from: 20;
                to: 40
            }
        }
        RotationAnimation{
            target: spinningProjectorWheel;
            duration: 1000;
            direction: RotationAnimation.Counterclockwise;
            from: 40;
            to: 0
        }
    }

    Image{
        id: table
        source: "Table.png"
        height: 250*.9
        width: 650*.9
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -100
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -300
        z:11

    }

    Image{
        id: lightsOffFilter
        source: "Lights_Off.png"
        anchors.centerIn: parent
        visible: true
        opacity: 0
        z: 20
    }
    NumberAnimation { id: lightsOffAnimation; target: lightsOffFilter; property: "opacity"; from: 0; to: 1; duration: 800; easing.type: Easing.InOutQuad }


    Image{
        id: screenOnFilter
        source: "Screen_ON.png"
        height: 860*.88
        width: 1440*.79
        anchors.top: screen.top
        anchors.topMargin: 56
        anchors.horizontalCenter: screen.horizontalCenter
        z: 21
        visible: true
        opacity: 0
    }
    NumberAnimation { id: screenOnAnimation; target: screenOnFilter; property: "opacity"; from: 0; to: 1; duration: 800; easing.type: Easing.InOutQuad }
    SequentialAnimation{
        id:flickerAnimation
        NumberAnimation {  target: screenOnFilter; property: "opacity"; from: 1; to: 0.5; duration: 50; easing.type: Easing.InOutQuad }
        NumberAnimation {  target: screenOnFilter; property: "opacity"; from: 0.5; to: 1; duration: 50; easing.type: Easing.InOutQuad }
    }


    Timer {
        id: introTimer
        interval: 10000; running: false; repeat: false
        onTriggered: {
            introTimer.stop();
            introScreen.state = "INVISIBLE";
            startScreen.state = "VISIBLE";
        }
    }

    Timer {
        id: lightsOffTimer
        interval: 200; running: false; repeat: false
        onTriggered:{
            lightsOffTimer.stop();
            lightsOffAnimation.start();
            screenOnTimer.start();
            bouncingFilmTimer.start();
        }
    }

    Timer{
        id: screenOnTimer
        interval: 200; running: false; repeat: false
        onTriggered:{
            screenOnTimer.stop();
            screenOnAnimation.start();
            flickerTimer.start();
        }
    }

    Timer{
        id: flickerTimer
        interval: getRandomNumber(); running: false; repeat: false;
        onTriggered:{
            flickerTimer.stop();
            flickerAnimation.start();
            flickerTimer.restart();
        }
    }

    Timer{
        id: bouncingFilmTimer
        interval: 1000; running: false; repeat: false
        onTriggered:{
            bouncingFilmTimer.stop();
            filmBounceAnimation.start();
            bouncingFilmTimer.restart();
        }
    }

    Text{
        anchors.horizontalCenter: introScreen.horizontalCenter
        anchors.bottom: introScreen.bottom
        anchors.bottomMargin: 10
        font.pointSize: 14
        color: '#6B6B6B'
        text: '(Spacebar to Skip)'
        z: parent.z + 1
    }

    Item{
        id: introKeySkip
        anchors.fill: parent
        focus: true

        Keys.onSpacePressed: {
            introTimer.stop();
            introScreen.state = "INVISIBLE";
            startScreen.state = "VISIBLE";
        }
    }

    Item {
        id: escKeyQuit
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: readyToExitGame();
    }

}

