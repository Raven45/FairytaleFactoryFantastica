import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0
import QtMultimedia 5.0

Rectangle {

    property int pieceIndex
    property int quadrantIndex
    property bool isLocked
    //scale: parent.scale
    SoundEffect {
            id: playSound
            source: "ButtonClick2.wav"
        }
    Glow {
       id: boardHole_glowEffect
       anchors.fill: backgroundImage
       radius: 16
       samples: 24
       spread: 0.5
       color: "yellow"
       source: backgroundImage
       visible: false
       fast: true
       cached: true
    }

    objectName: "BoardHoleButton"
    id: boardHoleButton
    x: -31
    y: -36
    width: 38
    height: 38
    clip: false
    color: "transparent"
    visible: true
    radius: 19
    z: 27

    Image {
        id: backgroundImage
        width: 100; height: 100
        x: -31; y: -36
        visible: false
        source: page.guiPlayerIsWhite ? "teal-gumdrop.png" : "purp-gumdrop.png"
    }

    SpriteSequence{
        id: icingSprite
        height: 100
        width: 100
        anchors.centerIn: parent
        visible: false

        //max 14
        property int sinkFrameDepth: 14

        sprites:[
            Sprite{
                name: "teal_sink"
                frameHeight: 150
                frameWidth: 150
                source: "tealIcingSinkSprite.png"
                frameCount: icingSprite.sinkFrameDepth
                frameX: 150
                frameY: 0
                frameDuration: 30

                to:{
                    "teal_sunk" : 1
                }

            },

            Sprite{
                name: "teal_sunk"
                frameHeight: 150
                frameWidth: 150
                source: "tealIcingSinkSprite.png"
                frameCount: 1
                frameX: 150 * icingSprite.sinkFrameDepth + 1
                frameY: 0
                frameDuration: 0

            },

            Sprite{
                name: "teal_start"
                frameHeight: 150
                frameWidth: 150
                source: "tealIcingSinkSprite.png"
                frameCount: 1
                frameX: 150
                frameY: 0
                frameDuration: 40
                to:{
                    "teal_sink":1
                }
            },

            Sprite{
                name: "purple_sink"
                frameHeight: 150
                frameWidth: 150
                source: "purpleIcingSinkSprite.png"
                frameCount: icingSprite.sinkFrameDepth
                frameX: 150
                frameY: 0
                frameDuration: 30

                to:{
                    "purple_sunk" : 1
                }

            },

            Sprite{
                name: "purple_sunk"
                frameHeight: 150
                frameWidth: 150
                source: "purpleIcingSinkSprite.png"
                frameCount: 1
                frameX: 150 * icingSprite.sinkFrameDepth + 1
                frameY: 0
                frameDuration: 0

            },

            Sprite{
                name: "purple_start"
                frameHeight: 150
                frameWidth: 150
                source: "purpleIcingSinkSprite.png"
                frameCount: 1
                frameX: 150
                frameY: 0
                frameDuration: 40
                to:{
                    "purple_sink":1
                }
            },

            Sprite{
                name: "spread"
                frameHeight: 150
                frameWidth: 150
                source: "icingSpread.png"
                frameCount: 1
                frameX: 0
                frameY: 0
                frameDuration: 0
            }
        ]

    }

    ParallelAnimation{
        id: spreadIcingAnimation
        running: false

        onStarted:{
            spreadIcing( quadrantIndex, pieceIndex );
        }

        NumberAnimation{
            target: icingSprite
            properties: "scale"
            from: 0; to: 1
            duration: _SPREAD_DURATION
        }
        RotationAnimation{
            target: icingSprite
            from: 360
            to: 0
            duration: _SPREAD_DURATION
        }

    }




    state: "EMPTY"


    Connections {

        target: page

        onPlaceOpponentsPiece: {
            if( qIndex === quadrantIndex && pIndex === pieceIndex ) {

                console.log("placing opponents piece at " + quadrantIndex + ", " + pieceIndex);

                icingSprite.visible = true;
                spreadIcingAnimation.start()
                icingSprite.jumpTo("spread");


                if( page.guiPlayerIsWhite ){
                    getFromCan( "PURPLE" );
                    stateChangeTimer.playerColor = "BLACK";

                }
                else{
                    getFromCan( "TEAL" );
                    stateChangeTimer.playerColor = "WHITE";
                }


                stateChangeTimer.startTimer();

            }
        }

        onClearBoard:{
            state = "EMPTY";
            icingSprite.visible = false;
        }

        onShowPiece:{
            if( qIndex == quadrantIndex && pIndex == pieceIndex ){
                showPieceTimer.startTimer();
            }
        }

        onRotationAnimationFinished:{



            if( quadrantRotated === quadrantIndex ){
                //console.log( "6. rearranging pieceIndex-es of quadrant " + quadrantRotated + " for a " + direction + " rotation, pieceIndex " + pieceIndex);

                //"which piece was I before the rotation?"
                //correct the pieceIndex because the rotation animation only animates and doesn't change values
                switch( pieceIndex ){
                case 0:
                    if( direction == 1 ){
                            pieceIndex = 6;
                    }else   {

                        pieceIndex = 2;
                    }
                    break;

                case 1:
                    if( direction == 1 ){
                            pieceIndex = 3;
                    }else   pieceIndex = 5;
                    break;

                case 2:
                    if( direction == 1 ){
                            pieceIndex = 0;
                    }else   pieceIndex = 8;
                    break;

                case 3:
                    if( direction == 1 ){
                            pieceIndex = 7;
                    }else   pieceIndex = 1;
                    break;
                case 4: break;
                case 5:
                    if( direction == 1 ){
                            pieceIndex = 1;
                    }else   pieceIndex = 7;
                    break;

                case 6:
                    if( direction == 1 ){
                            pieceIndex = 8;
                    }else   pieceIndex = 0;
                    break;

                case 7:
                    if( direction == 1 ){
                            pieceIndex = 5;
                    }else   pieceIndex = 3;
                    break;

                case 8:
                    if( direction == 1 ){
                            pieceIndex = 2;
                    }else   pieceIndex = 6;
                    break;

                default: console.log("ERROR, my pieceIndex is wrong: pieceIndex = " + pieceIndex); break;
                }
            }
        }
    }

    QmlTimer {
        id: showPieceTimer
        duration: _CLAW_OPEN_DURATION
        onTriggered: {
            icingSprite.visible = true;

            if( parent.state == "BLACK" ){
                icingSprite.jumpTo( "purple_start" );
            }
            else if( parent.state == "WHITE" ){
                icingSprite.jumpTo( "teal_start" );
            }




            if( isGuiPlayersTurn ){
                unlockQuadrantRotation();
            }
        }
    }

    Rectangle{
        id: dummy
        visible: false;
        color: "transparent"
    }

    states: [
        State {
            name: "EMPTY"
            PropertyChanges{
                target: backgroundImage
                visible: false
            }
        },

        State {
            name: "BLACK"
            PropertyChanges{
                target: backgroundImage
                visible: false
                source: "purp-gumdrop.png"

            }

            PropertyChanges {
                target: clawHouse
                x: getXYOffset( quadrantIndex, pieceIndex ).x
            }

            PropertyChanges{
                target: purpleClawPiece
                x: getXYOffset( quadrantIndex, pieceIndex ).x
                y: getXYOffset( quadrantIndex, pieceIndex ).y
            }

            StateChangeScript{
                name: "moveYSignal1"
                script:{
                    if( quadrantIndex == 0 || quadrantIndex == 1 ){
                       clawMovingUp()
                   }
                   else{
                       clawMovingDown()
                   }
                }
            }

            StateChangeScript{
                name: "moveYSignal2"
                script:{
                    finishedClawMovingY()
                }
            }

            StateChangeScript {
                name: "openPurpleClaw"
                script: {
                    readyToOpenClaw( quadrantIndex, pieceIndex, "PURPLE" );
                }

            }
        },
        State {
            name: "WHITE"
            PropertyChanges{
                target: backgroundImage
                visible: false
                source: "teal-gumdrop.png"
            }

            PropertyChanges {
                target: clawHouse
                x: getXYOffset( quadrantIndex, pieceIndex ).x
            }

            PropertyChanges{
                target: tealClawPiece
                x: getXYOffset( quadrantIndex, pieceIndex ).x
                y: getXYOffset( quadrantIndex, pieceIndex ).y
            }

            StateChangeScript{
                name: "moveYSignal1"
                script:{
                    if( quadrantIndex == 0 || quadrantIndex == 1 ){
                       clawMovingUp()
                   }
                   else{
                       clawMovingDown()
                   }
                }
            }

            StateChangeScript{
                name: "moveYSignal2"
                script:{
                    finishedClawMovingY()
                }
            }

            StateChangeScript {
                name: "openTealClaw"
                script: {
                    readyToOpenClaw( quadrantIndex, pieceIndex, "TEAL" );
                }

            }


        }
    ]

    transitions: [


        Transition {
            from: "EMPTY"
            to: "WHITE"

            SequentialAnimation{


                NumberAnimation {
                    targets: [tealClawPiece, clawHouse]
                    property: "x"
                    duration: _CLAW_MOVE_DURATION / 2
                }

                ScriptAction{
                    scriptName: "moveYSignal1"
                }

                NumberAnimation
                {
                    target: tealClawPiece;
                    property: "y"
                    duration: _CLAW_MOVE_DURATION / 2
                }

                ScriptAction{
                    scriptName: "moveYSignal2"
                }

                ScriptAction{
                    scriptName: "openTealClaw"
                }
            }
        },


        Transition {
            from: "EMPTY"
            to: "BLACK"

            SequentialAnimation{

                NumberAnimation {
                    targets: [purpleClawPiece, clawHouse]
                    property: "x"
                    duration: _CLAW_MOVE_DURATION / 2
                }


                ScriptAction{
                    scriptName: "moveYSignal1"
                }

                NumberAnimation {
                    target: purpleClawPiece;
                    property: "y"
                    duration: _CLAW_MOVE_DURATION / 2
                }

                ScriptAction{
                    scriptName: "moveYSignal2"
                }

                ScriptAction{
                    scriptName: "openPurpleClaw"
                }
            }
        }
    ]

    QmlTimer{
        id: stateChangeTimer
        property string playerColor
        duration: _CLAW_CAN_ANIMATION_DURATION
        onTriggered:{
            console.log( "timer triggered, changing state to " + playerColor )
            parent.state = playerColor;


        }
    }

    MouseArea{
        id: boardHole_mouseArea
        anchors.fill: boardHoleButton
        hoverEnabled: true

        onEntered: {
            if (!menuIsShowing && guiPlayerCanClickBoardHoleButton ) {
                if( boardHoleButton.state == "EMPTY" ) {
                    boardHole_glowEffect.visible = true;
                }
            }
        }

        onExited: {
            if( boardHole_glowEffect.visible == true ){
                boardHole_glowEffect.visible = false;
            }
        }

       onClicked: {

           if (!menuIsShowing && guiPlayerCanClickBoardHoleButton ){
                console.log("pieceIndex of click: " + pieceIndex );

                if( boardHoleButton.state == "EMPTY" ){
                    boardHole_glowEffect.visible = false;

                    icingSprite.visible = true;
                    spreadIcingAnimation.start()
                    icingSprite.jumpTo( "spread" );

                    if( guiPlayerIsWhite ) {
                         //boardHoleButton.state = "WHITE";
                        console.log( "calling getFromCan( TEAL )" );
                        getFromCan( "TEAL" );
                        stateChangeTimer.playerColor = "WHITE";
                     }
                     else {
                        //boardHoleButton.state = "BLACK";
                        console.log( "calling getFromCan( BLACK )" );
                        getFromCan( "PURPLE" );
                        stateChangeTimer.playerColor = "BLACK";
                     }

                    stateChangeTimer.startTimer();

                    gameController.setGuiTurnHole( quadrantIndex, pieceIndex);
                    page.gameMessage = "Choose a rotation.";
                    lockBoardPieces();

                    playSound.play()
                }
                else{
                   page.gameMessage = "This place is taken!";
                }
           }
       }
    }
}
