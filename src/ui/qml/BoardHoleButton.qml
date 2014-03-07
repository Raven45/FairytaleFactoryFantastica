import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0

Rectangle {

    property int pieceIndex
    property int quadrantIndex
    property bool isLocked

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
    z: 14

    Image{
        id: backgroundImage
        width: 100; height: 100
        x: -31; y: -36
        visible: false
        source: "teal-gumdrop.png"
    }
    state: "EMPTY" //...property binding didn't work but should have?


    Connections{

        target: page

        onPlaceOpponentsPiece: {
            if( qIndex === quadrantIndex && pIndex === pieceIndex ){

                console.log("o2: coloring opponents piece at " + quadrantIndex + ", " + pieceIndex);
                state = page.guiPlayerIsWhite? "BLACK" : "WHITE"

            }
        }

        onLockBoardPieces:{
            isLocked = true;

        }

        onUnlockBoardPieces:{
            isLocked = false;
        }

        onClearBoard:{
            state = "EMPTY";
        }


        onRotationAnimationFinished:{



            if( quadrantRotated === quadrantIndex ){
                console.log( "6. rearranging pieceIndex-es of quadrant " + quadrantRotated + " for a " + direction + " rotation, pieceIndex " + pieceIndex);

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

                default: console.log("oops, my pieceIndex is wrong: pieceIndex = " + pieceIndex); break;
                }
            }
        }
    }

    QmlTimer {
        id: showPieceTimer
        duration: _CLAW_OPEN_DURATION
        onTriggered: {
            backgroundImage.visible = true;
        }
    }

    Connections{
        target: page
        onShowPiece:{
            if( qIndex == quadrantIndex && pIndex == pieceIndex ){
                showPieceTimer.startTimer();
            }
        }
    }

    states: [
        State {
            name: "GLOWING"
            when: (boardHole_mouseArea.containsMouse && (state != "BLACK" && state != "WHITE") )
            PropertyChanges{ target: backgroundImage; visible: true }
            PropertyChanges{ target: boardHole_glowEffect; visible: true }
        },
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

            PropertyChanges{
                target: purpleClawPiece
                x: getXYOffset( quadrantIndex, pieceIndex ).x
                y: getXYOffset( quadrantIndex, pieceIndex ).y
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

            PropertyChanges{
                target: tealClawPiece
                x: getXYOffset( quadrantIndex, pieceIndex ).x
                y: getXYOffset( quadrantIndex, pieceIndex ).y
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
                    target: tealClawPiece
                    property: "y"
                    duration: _CLAW_MOVE_DURATION / 2
                }
                NumberAnimation {
                    target: tealClawPiece;
                    property: "x"
                    duration: _CLAW_MOVE_DURATION / 2
                }
                ScriptAction{
                    scriptName: "openTealClaw"
                }
            }
        },

        Transition {
            from: "GLOWING"
            to: "WHITE"

            SequentialAnimation{
                NumberAnimation {
                    target: tealClawPiece
                    property: "y"
                    duration: _CLAW_MOVE_DURATION / 2
                }
                NumberAnimation {
                    target: tealClawPiece;
                    property: "x"
                    duration: _CLAW_MOVE_DURATION / 2
                }
                ScriptAction{
                    scriptName: "openTealClaw"
                }
            }
        },

        Transition {
            from: "GLOWING"
            to: "BLACK"

            SequentialAnimation{
                NumberAnimation {
                    target: purpleClawPiece
                    property: "y"
                    duration: _CLAW_MOVE_DURATION / 2
                }
                NumberAnimation {
                    target: purpleClawPiece;
                    property: "x"
                    duration: _CLAW_MOVE_DURATION / 2
                }
                ScriptAction{
                    scriptName: "openPurpleClaw"
                }
            }
        },

        Transition {
            from: "EMPTY"
            to: "BLACK"

            SequentialAnimation{
                NumberAnimation {
                    target: purpleClawPiece
                    property: "y"
                    duration: _CLAW_MOVE_DURATION / 2
                }
                NumberAnimation {
                    target: purpleClawPiece;
                    property: "x"
                    duration: _CLAW_MOVE_DURATION / 2
                }
                ScriptAction{
                    scriptName: "openPurpleClaw"
                }
            }
        }
    ]


    MouseArea{
        id: boardHole_mouseArea
        anchors.fill: boardHoleButton
        hoverEnabled: true

       onClicked: {

           console.log("pieceIndex of click: " + pieceIndex );
           if( !isLocked ){
               if( boardHoleButton.state == "GLOWING" ){
                   if(guiPlayerIsWhite){
                        boardHoleButton.state = "WHITE";
                   }
                   else{
                       boardHoleButton.state = "BLACK";
                   }

                   console.log("calling gameController.setGuiTurnHole(...) (from QML) with quadrantIndex = " + quadrantIndex + " and pieceIndex = " + pieceIndex);
                   gameController.setGuiTurnHole( quadrantIndex, pieceIndex);
                   page.gameMessage = "Choose a rotation.";


               }
               else{
                    page.gameMessage = "This place is taken!";
               }
           }else{
               page.gameMessage = "Can't click that right now!"
           }

       }
    }
}
