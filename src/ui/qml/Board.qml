import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: pentagoBoard
    width: 575
    height: width
    anchors.centerIn: parent
    color: "transparent"


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
                opacity: 1
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

    Cogs {
        id: left_cogs
        anchors.top: parent.top
        anchors.topMargin: 190

        anchors.left: parent.left
        anchors.leftMargin: -(left_cogs.width/2)
    }

    Cogs {
        id: top_cogs
        rotation: 90
        anchors.top: parent.top
        anchors.topMargin: -(top_cogs.height/2)

        anchors.left: parent.left
        anchors.leftMargin: 385
    }

    Cogs {
        id: right_cogs
        rotation: 180
        anchors.top: parent.top
        anchors.topMargin: 385

        anchors.right: parent.right
        anchors.rightMargin: -(right_cogs.width/2)
    }

    Cogs {
        id: bottom_cogs
        rotation: -90
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (-bottom_cogs.height/2)

        anchors.left: parent.left
        anchors.leftMargin: 190
    }

    Tbar {
        anchors.top: parent.top
        anchors.left: parent.left

        pentago_quad: 0
        tbar_rotate_angle: -45
    }

    Tbar {
        anchors.top: parent.top
        anchors.right: parent.right

        pentago_quad: 1
        tbar_rotate_angle: 45
    }

    Tbar {
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        pentago_quad: 2
        tbar_rotate_angle: -135
    }

    Tbar {
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        pentago_quad: 3
        tbar_rotate_angle: 135
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


    function getXYOffset(quadrantIndex, pieceIndex){
        var xyOffset = { "x": 0, "y":0 };
        var distanceFromCenter = _QUADRANT_WIDTH/2 - _BOARD_HOLE_WIDTH/2;
        var xCenter;
        var yCenter;

        switch(quadrantIndex){
        case 0:
            xCenter = _VERTICAL_OUTSIDE + _QUADRANT_WIDTH/2;
            yCenter = _HORIZONTAL_TOP + _QUADRANT_WIDTH/2;
            break;
        case 1:
            xCenter = _VERTICAL_CENTER + _QUADRANT_WIDTH/2;
            yCenter = _HORIZONTAL_TOP + _QUADRANT_WIDTH/2;
            break;
        case 2:
            xCenter = _VERTICAL_OUTSIDE + _QUADRANT_WIDTH/2;
            yCenter = _HORIZONTAL_CENTER + _QUADRANT_WIDTH/2;
            break;
        case 3:
            xCenter = _VERTICAL_CENTER + _QUADRANT_WIDTH/2;
            yCenter = _HORIZONTAL_CENTER + _QUADRANT_WIDTH/2;
            break;

        }

        switch( pieceIndex ){
        case 0:
            xyOffset.x = xCenter - distanceFromCenter;
            xyOffset.y = yCenter - distanceFromCenter;
            break;
        case 1:
            xyOffset.x = xCenter;
            xyOffset.y = yCenter - distanceFromCenter;
            break;
        case 2:
            xyOffset.x = xCenter + distanceFromCenter;
            xyOffset.y = yCenter - distanceFromCenter;
            break;
        case 3:
            xyOffset.x = xCenter - distanceFromCenter;
            xyOffset.y = yCenter;
            break;
        case 4:
            xyOffset.x = xCenter;
            xyOffset.y = yCenter;
            break;
        case 5:
            xyOffset.x = xCenter + distanceFromCenter;
            xyOffset.y = yCenter;
            break;
        case 6:
            xyOffset.x = xCenter - distanceFromCenter;
            xyOffset.y = yCenter + distanceFromCenter;
            break;
        case 7:
            xyOffset.x = xCenter;
            xyOffset.y = yCenter + distanceFromCenter;
            break;
        case 8:
            xyOffset.x = xCenter + distanceFromCenter;
            xyOffset.y = yCenter + distanceFromCenter;
            break;
        }

        console.log( " moving to x: " + xyOffset.x +" and y: " + xyOffset.y );

        return xyOffset;
    }


    Image{
        id: steel_platform
        fillMode: Image.PreserveAspectFit
        width : 420
        height: width
        anchors.centerIn: parent
        source: "steel-platform.png"
    }

    Rectangle {
        id: quads_rec
        width: 410
        height: width
        color: "transparent"
        anchors.centerIn: pentagoBoard
        border.color: "#363666"

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




    ClawPiece {
        type: "PURPLE"
        id: purpleClawPiece
        z: 10
        source: "purp-claw-spritesheet.png"
        x: _CLAW_X_HOME
        y: _CLAW_Y_HOME
    }

    ClawPiece {
        type: "TEAL"
        id: tealClawPiece
        z: 10
        source: "teal-claw-spritesheet.png"
        x: _CLAW_X_HOME
        y: _CLAW_Y_HOME
    }


}
