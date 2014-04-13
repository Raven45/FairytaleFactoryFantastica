import QtQuick 2.0

SequentialAnimation {

    property int animationDirection

    alwaysRunToEnd: true

    onStarted:{
        root.z++;
        turnCogs( myIndex, animationDirection == 0? "RIGHT" : "LEFT" );
    }
    onStopped:{
        root.z--;
        rotationAnimationFinished( myIndex, animationDirection );

        if( tealLightBlink.running ){
            tealLightBlink.stop();
            tealLightOn.opacity = 0;
            purpleLightBlink.start();
        }
        else{
            purpleLightBlink.stop();
            purpleLightOn.opacity = 0;
            tealLightBlink.start();
        }


        waitingForRotationAnimationToFinish = false;

    }

    NumberAnimation {
        target: root;
        properties: "scale";
        running: false;
        to: _QUADRANT_GROWTH;
        alwaysRunToEnd: true
        duration: 150
    }
    NumberAnimation {
        target: root;
        properties: "rotation";
        duration: _ROTATION_ANIMATION_DURATION - 300;
        alwaysRunToEnd: true
        running: false;
        from: rotation; to: animationDirection == 0? rotation + 90 : rotation - 90;
    }
    NumberAnimation {
        target: root;
        properties: "scale";
        to: 1;
        running: false;
        alwaysRunToEnd: true
        duration: 150
    }
}
