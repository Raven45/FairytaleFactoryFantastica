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
        property int counter: 10
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
        challengePopup.state = "INVISIBLE";
        networkLobby.state = "INVISIBLE";
        startMenu.state = "INVISIBLE";
        unlockBoardPieces();
        lockQuadrantRotation();

        //we need to save it so we can put it back later, fixes a bug where returning to main menu at starting a game and the guiPlayerIsWhite is wrong
        guiPlayerIsWhiteAtEnter = guiPlayerIsWhite;
        guiPlayerIsWhite = true;

        sendThisChallengeResponse( true );
    }

    button1Text: "Decline"
    onButton1Clicked: {
       declineChallengeFunction();
    }

    function resetValues(){
        challengeTimer.counter = 10;
        challengeTimerText.text = '10';
    }

    function declineChallengeFunction(){
        console.log("GUI is declining challenge.");
        challengePopup.state = "INVISIBLE";
        challengeTimer.stop();
        resetValues();
        sendThisChallengeResponse(false);
    }
}
