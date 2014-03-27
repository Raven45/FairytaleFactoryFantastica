import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import QtMultimedia 5.0

Image {
    id: root
    fillMode: Image.PreserveAspectFit
    objectName: "Quadrant"
    width: 200
    height: width
    z: 22
    source: "grahm-quad.png"

    SoundEffect {
            id: rotationSound
            source: "ChainCrank1.wav"
        }
    property int myIndex
    property int xCenter
    property int yCenter

    function rotate( direction ){

        rotationSound.play()
        rotationAnimation.animationDirection = direction;
        rotationAnimation.start();

        if(bhb0.state == "EMPTY")
            bhb0.rotation += (direction === 0)? -90 : 90;
        if(bhb1.state == "EMPTY")
            bhb1.rotation += (direction === 0)? -90 : 90;
        if(bhb2.state == "EMPTY")
            bhb2.rotation += (direction === 0)? -90 : 90;
        if(bhb3.state == "EMPTY")
            bhb3.rotation += (direction === 0)? -90 : 90;
        if(bhb4.state == "EMPTY")
            bhb4.rotation += (direction === 0)? -90 : 90;
        if(bhb5.state == "EMPTY")
            bhb5.rotation += (direction === 0)? -90 : 90;
        if(bhb6.state == "EMPTY")
            bhb6.rotation += (direction === 0)? -90 : 90;
        if(bhb7.state == "EMPTY")
            bhb7.rotation += (direction === 0)? -90 : 90;
        if(bhb8.state == "EMPTY")
            bhb8.rotation += (direction === 0)? -90 : 90;

    }

    function resetRotations(){
            root.rotation = 0;

            bhb0.rotation = 0;
            bhb0.pieceIndex = 0;
            bhb1.rotation = 0;
            bhb1.pieceIndex = 1;
            bhb2.rotation = 0;
            bhb2.pieceIndex = 2;
            bhb3.rotation = 0;
            bhb3.pieceIndex = 3;
            bhb4.rotation = 0;
            bhb4.pieceIndex = 4;
            bhb5.rotation = 0;
            bhb5.pieceIndex = 5;
            bhb6.rotation = 0;
            bhb6.pieceIndex = 6;
            bhb7.rotation = 0;
            bhb7.pieceIndex = 7;
            bhb8.rotation = 0;
            bhb8.pieceIndex = 8;
    }


    Item{
        property int animationDirection
        id: rotationAnimation

        function start(){
            if( animationDirection == 0 ){
                rightRotation.start();
            }
            else{
                leftRotation.start();
            }
        }

        QuadrantRotationAnimation{
            id: rightRotation
            animationDirection: 0
        }

        QuadrantRotationAnimation{
            id: leftRotation
            animationDirection: 1
        }
    }



    BoardHoleButton{
        id: bhb0
        anchors.leftMargin: 15
        anchors.topMargin: 13
        anchors.left: parent.left
        anchors.top: parent.top
        pieceIndex: 0
        quadrantIndex: myIndex

    }
    BoardHoleButton{
        id: bhb1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 13
        pieceIndex: 1
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        id: bhb2
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 13
        anchors.rightMargin: 15
        pieceIndex: 2
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        id: bhb3
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 15
        pieceIndex: 3
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        id: bhb4
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        pieceIndex: 4
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        id: bhb5
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 15
        pieceIndex: 5
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        id: bhb6
        anchors.leftMargin: 15
        anchors.bottomMargin: 13
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        pieceIndex: 6
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        id:bhb7
        anchors.bottomMargin: 13
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        pieceIndex: 7
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        id:bhb8
        anchors.rightMargin: 15
        anchors.bottomMargin: 13
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        pieceIndex: 8
        quadrantIndex: myIndex
    }
}
