import QtQuick 2.0
import QtQuick.Window 2.1
import QtMultimedia 5.0

//! [splash-properties]
Rectangle {
    id: introScreen
    width: parent.width; height: parent.height
    visible: false
    anchors.fill: parent
    z:100

    property int slideNumber: 1
    property string slideSourceString: "Slide" + slideNumber + ".png"

    function getRandomNumber(){
        var number = rand();
        while (number > 1800 || number < 300)
        {
            number = rand();
        }
        console.log("random number = " + number);
        return number;
    }

    SoundEffect {
        id: playProjector
        source: "Projector.wav"
    }

    states: [
        State{
            name: "VISIBLE"
            PropertyChanges { target: introKeySkip; focus: true }
            PropertyChanges{target: introScreen; visible: true}
            PropertyChanges{target: introTimer; running: true}
            PropertyChanges{target: lightsOffTimer; running: true}
        },
        State{
            name: "INVISIBLE"
            PropertyChanges{target: introKeySkip; focus: false}
            PropertyChanges{target: introScreen; visible: false}
            PropertyChanges{target: introTimer; running: false}
            PropertyChanges{target: lightsOffTimer; running: false}
            PropertyChanges{target: screenOnTimer; running: false}
            PropertyChanges{target: flickerTimer; running: false}
            PropertyChanges{target: bouncingFilmTimer; running: false}
            StateChangeScript{ name: turnOffSound; script: playProjector.stop() }
            StateChangeScript{ name: resetProjector; script: slideNumber = 1 }

        }
    ]

    Image{
        id: introScreen_background
        source: "IntroScreen-Background.png"
        z: 1
        anchors.bottom: parent.bottom
    }

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
        z:35

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
        id: projectorlight
        source: "Projector_Light.png"
        height: 350
        width: 250
        anchors.bottom: projector.top
        anchors.bottomMargin: -85
        anchors.right: projector.right
        anchors.rightMargin: -75
        z:3
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
        z:36
        visible: true
        opacity: 0

    }

    Image{
        id: slide
        source: slideSourceString
        height: 860*.57
        width: 1440*.57
        anchors.top: screen.top
        anchors.topMargin: 125
        anchors.horizontalCenter: screen.horizontalCenter
        anchors.horizontalCenterOffset: 30
        z: 31
        opacity: 0
        fillMode: Image.PreserveAspectFit
    }

    Image{
        id: hideSlide
        source: "HideSlide.png"
        height: 960
        width: 1440*.80
        anchors.top: parent.top
        anchors.topMargin: -80
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -126
        rotation: -1
        z:51
        visible: false
        fillMode: Image.PreserveAspectCrop
    }


    SequentialAnimation{
        id: filmBounceAnimation
        ParallelAnimation{
            NumberAnimation { target: film; property: "opacity"; from: 0; to: 100; duration: 700; easing.type: Easing.InBack }
            NumberAnimation { target: film; property: "y"; from: film.y; to: film.y-25; duration: 700; easing.type: Easing.InBack }
            //NumberAnimation { target: slide; property: "opacity"; from: .7; to: 0; duration: 400; easing.type: Easing.InBack }
            NumberAnimation { target: slide; property: "anchors.topMargin"; from: 125; to: -250; duration: 600; easing.type: Easing.InBack }
            RotationAnimation{
                target: spinningProjectorWheel;
                duration: 500;
                direction: RotationAnimation.Clockwise;
                from: 0;
                to: 20
            }
        }
        ScriptAction { script: slideNumber++;}

        ParallelAnimation{
            NumberAnimation { target: film; property: "opacity"; from: 100; to: 0; duration: 700; easing.type: Easing.OutBack }
            NumberAnimation { target: film; property: "y"; from: film.y-25; to: film.y; duration: 700; easing.type: Easing.OutBack }
            NumberAnimation { target: slide; property: "opacity"; from: 0; to: .7; duration: 400; easing.type: Easing.InBack }
            NumberAnimation { target: slide; property: "anchors.topMargin"; from: -250; to: 125; duration: 600; easing.type: Easing.InBack }
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
    NumberAnimation { id: turnSlideOn; target: slide; property: "opacity"; from: 0; to: .7; duration: 400; easing.type: Easing.InBack }

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
    NumberAnimation { id: screenOnAnimation; target: screenOnFilter; property: "opacity"; from: 0; to: 1; duration: 800; easing.type: Easing.InOutQuad; onStarted: if(_SOUND_CHECK_FLAG) playProjector.play(); onStopped: hideSlide.visible = true;}
    SequentialAnimation{
        id:flickerAnimation
        ParallelAnimation{
            NumberAnimation {  target: screenOnFilter; property: "opacity"; from: 1; to: 0.5; duration: 50; easing.type: Easing.InOutQuad }
            NumberAnimation {  target: projectorlight; property: "opacity"; from: 1; to: 0.5; duration: 50; easing.type: Easing.InOutQuad }
        }
        ParallelAnimation{
            NumberAnimation {  target: screenOnFilter; property: "opacity"; from: 0.5; to: 1; duration: 50; easing.type: Easing.InOutQuad }
            NumberAnimation {  target: projectorlight; property: "opacity"; from: 0.5; to: 1; duration: 50; easing.type: Easing.InOutQuad }
        }
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

        }
    }

    Timer{
        id: screenOnTimer
        interval: 200; running: false; repeat: false
        onTriggered:{
            screenOnTimer.stop();
            screenOnAnimation.start();
            turnSlideOn.start();
            bouncingFilmTimer.start();
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
        interval: 3150; running: false; repeat: false
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
        focus: false

        Keys.onSpacePressed: {
            introTimer.stop();
            introScreen.state = "INVISIBLE";
            startScreen.state = "VISIBLE";
        }
    }

}


