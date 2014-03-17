import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Image {
    id: root
    fillMode: Image.PreserveAspectFit
    objectName: "Quadrant"
    width: 200
    height: width
    z: 1
    source: "grahm-quad.png"

    property int myIndex
    property int xCenter
    property int yCenter

    function rotate( direction ){
        if( parseInt(direction) === 0 ){

            rightRotation.start()
            turnCogs( myIndex, "RIGHT")
        }
        else{
            leftRotation.start()
            turnCogs( myIndex, "LEFT")
        }
    }


    SequentialAnimation {
        id: rightRotation
        property int animationDirection: 0
        onStarted:{
            //console.log("in rotationAnimation onStarted. myIndex = " + myIndex );
            root.z += 100;
        }
        onStopped:{
            root.z -= 100;
            rotationAnimationFinished( myIndex, animationDirection );
            //console.log("in rotationAnimation onStopped. myIndex = " + myIndex );
        }

        NumberAnimation {
          target: root
          properties: "width,height"
          from: _QUADRANT_WIDTH
          to: _QUADRANT_WIDTH + _QUADRANT_GROWTH
          duration: 100
        }

        NumberAnimation {
            target: root
            properties: "rotation"
            duration: _ROTATION_ANIMATION_DURATION - 200
            //easing {type: Easing.InElastic}
            running: false
            from: rotation
            to: rotation + 90
            property int animationDirection: 0
        }
        NumberAnimation {
          target: root
          properties: "width,height"
          from: _QUADRANT_WIDTH + _QUADRANT_GROWTH
          to: _QUADRANT_WIDTH
          duration: 100
        }
    }

    SequentialAnimation {
        id: leftRotation
        property int animationDirection: 1
        onStarted:{
            //console.log("in rotationAnimation onStarted. myIndex = " + myIndex );
            root.z += 100;
        }
        onStopped:{
            root.z -= 100;
            rotationAnimationFinished( myIndex, animationDirection );
            //console.log("in rotationAnimation onStopped. myIndex = " + myIndex );
        }

        NumberAnimation {
          target: root
          properties: "width,height"
          from: _QUADRANT_WIDTH
          to: _QUADRANT_WIDTH + _QUADRANT_GROWTH
          duration: 100
        }

        NumberAnimation {
            target: root
            properties: "rotation"
            duration: _ROTATION_ANIMATION_DURATION - 200
            //easing {type: Easing.InElastic}
            running: false
            from: rotation
            to: rotation - 90
            property int animationDirection: 0
        }
        NumberAnimation {
          target: root
          properties: "width,height"
          from: _QUADRANT_WIDTH + _QUADRANT_GROWTH
          to: _QUADRANT_WIDTH
          duration: 100
        }
    }

    BoardHoleButton{
        anchors.leftMargin: 15
        anchors.topMargin: 13
        anchors.left: parent.left
        anchors.top: parent.top
        pieceIndex: 0
        quadrantIndex: myIndex

    }
    BoardHoleButton{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 13
        pieceIndex: 1
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 13
        anchors.rightMargin: 15
        pieceIndex: 2
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 15
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
        anchors.rightMargin: 15
        pieceIndex: 5
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.leftMargin: 15
        anchors.bottomMargin: 13
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        pieceIndex: 6
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.bottomMargin: 13
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        pieceIndex: 7
        quadrantIndex: myIndex
    }
    BoardHoleButton{
        anchors.rightMargin: 15
        anchors.bottomMargin: 13
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        pieceIndex: 8
        quadrantIndex: myIndex
    }
}
