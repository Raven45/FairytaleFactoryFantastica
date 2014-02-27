import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: pentagoBoard
    width: 750
    height: width
    color: "#343434"

    state: "LOCKED"

    Connections{
        target: page
        onReadyForRotation:{

            lockBoardPieces();

            //TODO here:
            //unlock rotation buttons
            //get real rotation info
            //setup another signal layer before calling guiMoveChosen
        }
    }


    states: [
        State{
            name: "LOCKED"
            PropertyChanges {
                target: pentagoBoard
                opacity: 0.5
            }

        },
        State{
            name: "UNLOCKED"
            PropertyChanges {
                target: pentagoBoard
                opacity: 1
            }
        }

    ]


    Arrow{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 30
        myRotation: 45
        myQuadrantToRotate: 0
        myRotationDirection: 0
    }

    Arrow{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 30
        rotation: 225
        myMirror: true
        myQuadrantToRotate: 0
        myRotationDirection: 1
    }

    Arrow{
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 30
        rotation: 315
        myMirror: true
        myQuadrantToRotate: 1
        myRotationDirection: 1
    }

    Arrow{
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 30
        rotation: 135
        myQuadrantToRotate: 1
        myRotationDirection: 0
    }

    Arrow{
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 30
        rotation: 135
        myMirror: true
        myQuadrantToRotate: 2
        myRotationDirection: 1
    }

    Arrow{
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        rotation: 315
        myQuadrantToRotate: 2
        myRotationDirection: 0
    }

    Arrow{
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 30
        rotation: 225
        myQuadrantToRotate: 3
        myRotationDirection: 0
    }

    Arrow{
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        rotation: 45
        myMirror: true
        myQuadrantToRotate: 3
        myRotationDirection: 1
    }

    function playRotateAnimationOnQuadrant( quadrantIndex, direction ){

        switch( parseInt( quadrantIndex ) ){
            case 0: quadrant0.rotate(direction);break;
            case 1: quadrant1.rotate(direction);break;
            case 2: quadrant2.rotate(direction);break;
            case 3: quadrant3.rotate(direction);break;
            default: console.log( "Oops! bad quadrantIndex of " + quadrantIndex + " received.\n" );
        }
    }


    Rectangle {

    width: 410
    height: width
    color: "#343434"
    anchors.centerIn: parent


        Quadrant{
            id: quadrant0
            anchors.left: parent.left
            anchors.top: parent.top
            myIndex: 0
        }
        Quadrant{
            id: quadrant1
            anchors.right: parent.right
            anchors.top: parent.top
            myIndex: 1
        }
        Quadrant{
            id: quadrant2
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            myIndex: 2
        }
        Quadrant{
            id: quadrant3
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            myIndex: 3
        }


    }
}
