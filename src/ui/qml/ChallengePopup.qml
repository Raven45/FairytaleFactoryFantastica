import QtQuick 2.0
import QtQuick.Controls 1.0

GenericPopup {
    id: challengePopup
    z: 200

    Connections {
        target: page
        onChallengeReceivedFromNetwork:{
            message = "You have been challenged by " + challengerName.toString() + "!";
            state = "VISIBLE";
            challengeTimer.start();
        }
    }

    message: "You have been challenged by NOBODY"

    Text {
        id: challengeTimerText
        font.pointSize: 20
        text: "9"
        color: "red"
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 15
    }

    Timer {
        id: challengeTimer
        property int counter: 9
        interval: 1000
        onTriggered:{
           challengeTimerText.text = counter.toString();
           counter--;

            if( counter >= 0 ){
                challengeTimer.start();
            }
            else{
                declineChallengeFunction();
            }
        }
    }

    button2Text: "Accept"
    onButton2Clicked: {
        challengeTimer.stop();
        resetValues();
        placeCharacterOnPlatform( "hansel", "teal");
        placeCharacterOnPlatform( "witch", "purple");
        challengePopup.state = "INVISIBLE";
        networkLobby.state = "INVISIBLE";
        leaveForkliftMenuToGameScreen();
        unlockBoardPieces();
        lockQuadrantRotation();

        movingPlayerIsTeal = true;
        movingPlayerIsNetworkOrAI = false;
        networkOrAIIsTeal = false;
        sendThisChallengeResponse( true );
    }

    button1Text: "Decline"
    onButton1Clicked: {
       declineChallengeFunction();
    }

    function resetValues(){
        challengeTimer.counter = 9;
        challengeTimerText.text = '9';
    }

    function declineChallengeFunction(){
        console.log("GUI is declining challenge.");
        challengePopup.state = "INVISIBLE";
        challengeTimer.stop();
        resetValues();
        sendThisChallengeResponse(false);
    }
}
