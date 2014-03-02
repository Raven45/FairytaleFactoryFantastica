import QtQuick 2.0

Item {

    property string source

    Connections{
        target:page
        onReadyToOpenClaw:{
            if( type == whichClaw ){
                clawSprite.start()
                clawSpriteTimer.startTimer()
                showPiece( qIndex, pIndex );
            }
        }
    }

    QmlTimer{
        id: clawSpriteTimer
        duration: _CLAW_OPEN_DURATION * clawSprite.frameCount + 20
        onTriggered:{
            console.log("moving to home")
            moveToHome.start()

            if( (guiPlayerIsWhite && type == "TEAL" ) || (!guiPlayerIsWhite && type == "PURPLE") ){
                readyForRotation();
            }
        }

    }


    NumberAnimation on x{
        id: moveToHome
        to: _CLAW_X_HOME
        duration: 400

        onStopped: {
            x = _CLAW_X_HOME;
            moveYToHome.start();
        }
    }

    NumberAnimation on y{
        id: moveYToHome
        to: _CLAW_Y_HOME
        duration: 400

        onStopped: {
            y = _CLAW_Y_HOME;
        }
    }





    property string type

    AnimatedSprite {
        id: clawSprite
        width: 131
        height: 131
        source: parent.source
        frameCount: 72
        frameDuration: _CLAW_OPEN_DURATION
        frameWidth: 200
        frameHeight: 200
        loops: 1
        running: false
        z: 410
    }


    Rectangle {
        id: clawPipe
        width: 22
        height:  1000
        anchors.bottom: clawSprite.top
        anchors.bottomMargin: -13
        anchors.horizontalCenter: clawSprite.horizontalCenter
        anchors.horizontalCenterOffset: -3
        color: "#000000"
        z: 400
    }

}
