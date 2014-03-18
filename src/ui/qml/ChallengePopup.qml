import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    id: challengePopup
    width: 300
    height: 250
    z: 200
    color: "#FF2A48"
    state: "INVISIBLE"

    states: [
        State{
            name: "VISIBLE"
            PropertyChanges {
                target: challengePopup
                visible: true
            }

        },
        State{
            name: "INVISIBLE"
            PropertyChanges {
                target: challengePopup
                visible: false
            }
        }

    ]

    Connections{
        target: page
        onChallengeReceivedFromNetwork:{
            var challengingPlayerName = challengerName.toString();
            var challengerIpAddress = stringAddressOfPlayerWhoChallenged.toString();
            challengingPlayer.text = "You have been challenged by " + challengingPlayerName + "!";
            challengingPlayerAddress.text = challengerIpAddress + "is his computer address.";
            state = "VISIBLE";
            challengeTimer.start();
        }
    }

    Text{
      id: challengeTextBox
      text: "Network Game Challenge"
      font.pointSize: 18
      font.bold: true
      anchors.top: challengePopup.top
      anchors.horizontalCenter: challengePopup.horizontalCenter
      anchors.topMargin: 5
    }

    Text{
      id: challengingPlayer
      text: "player"
      font.pointSize: 15
      anchors.top: challengeTextBox.bottom
      anchors.horizontalCenter: challengePopup.horizontalCenter
      anchors.topMargin: 5
    }

    Text{
      id: challengingPlayerAddress
      text: "address"
      font.pointSize: 15
      anchors.top: challengingPlayer.bottom
      anchors.horizontalCenter: challengePopup.horizontalCenter
    }

    Text {
        id: challengeTimerText
        font.pointSize: 15
        text: "9"
        anchors.top: challengingPlayerAddress.bottom
        anchors.horizontalCenter: challengePopup.horizontalCenter
    }

    Timer {
        id: challengeTimer
        property int counter: 9
        interval: 1000
        onTriggered:{
           challengeTimerText.text = counter.toString();
           counter--;

            if( counter > 0 ){
                challengeTimer.start();
            }
            else{
                declineChallengeFunction();
            }
        }


    }

    function resetValues(){
        challengeTimer.counter = 9;
        challengeTimerText.text = '9';
    }

    Button {
        id: acceptChallenge
        width: 100
        height: 50
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        text: "Accept"
        onClicked: {
            challengeTimer.stop();
            resetValues();
            challengePopup.state = "INVISIBLE";
            networkLobby.state = "INVISIBLE";
            pentagoBoard.state = "UNLOCKED";
            unlockBoardPieces();
            lockQuadrantRotation();
            guiPlayerIsWhite = true;
            sendThisChallengeResponse( true );
        }
    }

    Button {
        id: declineChallenge
        width: 100
        height: 50
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: "Decline"

        onClicked: {
           declineChallengeFunction();
        }
    }

    function declineChallengeFunction(){
        console.log("GUI is declining challenge.");
        challengePopup.state = "INVISIBLE";
        challengeTimer.stop();
        resetValues();
        sendThisChallengeResponse(false);
    }
}
