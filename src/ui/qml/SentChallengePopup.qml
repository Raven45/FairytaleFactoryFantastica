import QtQuick 2.0

import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    id: sentChallengePopup
    width: 300
    height: 250
    z: 200

    property bool challengeNotYetAccepted: true

    color: "#FF2A48"
    state: "INVISIBLE"

    states: [
        State{
            name: "VISIBLE"
            PropertyChanges {
                target: sentChallengePopup
                visible: true
            }
        },
        State{

            name: "INVISIBLE"

            PropertyChanges {
                target: sentChallengePopup
                visible: false
            }
        }

    ]

    Connections{
        target: page

        onSendThisChallenge:{
            sentChallengePopup.state = "VISIBLE";
            challengeResponseTimer.start();
        }

        onChallengeWasAccepted:{
            challengeResponseTimer.stop();
            resetValues();
            challengeNotYetAccepted = false;
            challengeResponseTimerText.text = "CHALLENGE ACCEPTED!!";
            challengeResponseResultTimer.wasAccepted = true;
            challengeResponseResultTimer.start();

            //challenger does not move first
            isFirstMoveOfGame = false;
            guiPlayerIsWhite = false;
            lockBoardPieces();
            lockQuadrantRotation();
        }

        onChallengeWasDeclined:{
            challengeResponseTimer.stop();
            resetValues();
            challengeResponseTimerText.text = "CHALLENGE DECLINED.";
            challengeResponseResultTimer.wasAccepted = false;
            challengeResponseResultTimer.start();
        }
    }

    Timer {
        id: challengeResponseResultTimer
        interval: 1000
        property bool wasAccepted
        onTriggered:{
           sentChallengePopup.state = "INVISIBLE";
           challengeResponseTimer.counter = 9;
           challengeResponseTimerText.text = '9';

           if( wasAccepted ){
               networkLobby.state = "INVISIBLE";
               pentagoBoard.state = "UNLOCKED";
           }
           else{
               networkLobby.state = "VISIBLE";
           }
        }
    }

    Text{
      id: sentChallengeTextBox
      text: "Waiting for response..."
      font.pointSize: 18
      font.bold: true
      anchors.top: sentChallengePopup.top
      anchors.horizontalCenter: sentChallengePopup.horizontalCenter
      anchors.topMargin: 5
    }

    Text {
        id: challengeResponseTimerText
        font.pointSize: 15
        text: "9"
        anchors.top: sentChallengeTextBox.bottom
        anchors.horizontalCenter: sentChallengePopup.horizontalCenter
    }

    Timer {
        id: challengeResponseTimer
        property int counter: 9
        interval: 1000
        onTriggered:{
           challengeResponseTimerText.text = counter.toString();
           counter--;

            if( counter >= 0 ){
                challengeResponseTimer.start();
            }
            else{
                if( challengeNotYetAccepted ){
                    resetValues();
                }
            }
        }

    }

    function resetValues(){
        challengeResponseTimer.counter = 9;
        challengeResponseTimerText.text = '9';
    }


}




