import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {

    property int pieceIndex
    property int quadrantIndex
    property bool isLocked

    objectName: "BoardHoleButton"
    id: boardHoleButton
    width: 70
    height: 70
    clip: false
    visible: true
    radius: 35
    z: 14

    state: "EMPTY" //...property binding didn't work but should have?


    Connections{

        target: page

        onPlaceOpponentsPiece: {
            if( qIndex === quadrantIndex ){
                if( pIndex === pieceIndex ){

                    console.log("o2: coloring opponents piece at " + quadrantIndex + ", " + pieceIndex);
                    state = page.guiPlayerIsWhite? "BLACK" : "WHITE"
                }
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
                switch( pieceIndex ){
                case 0:
                    if( direction == 1 ){
                            pieceIndex = 6;
                    }else   pieceIndex = 2;
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

    states: [
        State {
            name: "EMPTY"
            PropertyChanges{
                target: boardHoleButton
                color: "transparent"
            }
        },
        State {
            name: "BLACK"
            PropertyChanges{
                target: boardHoleButton
                color: "black"
            }
        },
        State {
            name: "WHITE"
            PropertyChanges{
                target: boardHoleButton
                color: "white"
            }
        }
    ]

    MouseArea{
        anchors.fill: parent
       onClicked: {

           console.log("pieceIndex of click: " + pieceIndex );
           if( !isLocked ){
               if( boardHoleButton.state == "EMPTY" ){
                   if(guiPlayerIsWhite){
                        boardHoleButton.state = "WHITE";
                   }
                   else{
                       boardHoleButton.state = "BLACK";
                   }

                   console.log("1. set setGuiTurnHole ");
                   gameController.setGuiTurnHole( quadrantIndex, pieceIndex);
                   page.gameMessage = "Choose a rotation.";
                   readyForRotation();

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
