import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Image {
    fillMode: Image.PreserveAspectFit
    objectName: "Quadrant"
    width: 300
    height: width
    z: 1
    source: "pentago-quad.png"

    property int myIndex
    property int xCenter
    property int yCenter

    function rotate( direction ){

        if( parseInt(direction) === 0 ){
            rightRotation.start()
        }
        else{
            leftRotation.start()
        }
    }

    RotationAnimation on rotation {
        id: rightRotation
        duration: page._ROTATION_ANIMATION_DURATION
        //easing {type: Easing.InElastic}
        running: false
        from: rotation
        to: rotation + 90
        property int animationDirection: 0

        onStopped:{
            console.log("in rotationAnimation onStopped. myIndex = " + myIndex );
            rotationAnimationFinished( myIndex, animationDirection );
        }

        onStarted:{
            console.log("in rotationAnimation onStarted. myIndex = " + myIndex );
        }
    }

    RotationAnimation on rotation {
        id: leftRotation
        duration: page._ROTATION_ANIMATION_DURATION
        //easing {type: Easing.OutElastic}
        running: false
        from: rotation
        to: rotation - 90
        property int animationDirection: 1

        onStopped:{
            console.log("in rotationAnimation onStopped. myIndex = " + myIndex );
            rotationAnimationFinished( myIndex, animationDirection );
        }

        onStarted:{
            console.log("in rotationAnimation onStarted. myIndex = " + myIndex );
        }
    }

    BoardHoleButton{
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.top: parent.top
        pieceIndex: 0
        quadrantIndex: myIndex

    }
    BoardHoleButton{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        pieceIndex: 1
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.right: parent.right
        anchors.top: parent.top
        pieceIndex: 2
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        pieceIndex: 3
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        pieceIndex: 4
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        pieceIndex: 5
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        pieceIndex: 6
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        pieceIndex: 7
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        pieceIndex: 8
        quadrantIndex: myIndex
    }
}
