import QtQuick 2.0

import QtQuick 2.0
import QtQuick.Controls 1.0

GenericPopup {
    id: sentChallengePopup
    z: 200

    property bool challengeNotYetAccepted: true

    Connections{
        target: page

        onSendThisChallenge:{
            sentChallengePopup.state = "VISIBLE";
            challengeResponseTimer.start();
        }

        onChallengeWasAccepted:{
            challengeResponseTimer.stop();
            challengeNotYetAccepted = false;
            challengeResponseTimerText.text = "";
            message = "CHALLENGE ACCEPTED!";
            challengeResponseResultTimer.wasAccepted = true;
            challengeResponseResultTimer.start();

            //challenger does not move first
            isFirstMoveOfGame = false;

            movingPlayerIsNetworkOrAI = true;
            networkOrAIIsTeal = true;
            movingPlayerIsTeal = true;

            lockBoardPieces();
            lockQuadrantRotation();
        }

        onChallengeWasDeclined:{
            challengeResponseTimer.stop();
            resetValues();
            challengeResponseTimerText.text = "";
            message = "CHALLENGE DECLINED.";
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
           resetValues();

           if( wasAccepted ){
               networkLobby.state = "INVISIBLE";
               startMenu.state = "INVISIBLE";
           }
           else{
               networkLobby.state = "VISIBLE";
           }
        }
    }

    property string defaultMessage: "Waiting for response..."
    message: defaultMessage

    hideButtons: true

    Text {
        id: challengeResponseTimerText
        font.pointSize: 20
        text: "9"
        color: "red"
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 15
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

                    // 3/17/2014 resume working here in the morning
                    challengeWasDeclined();
                    challengeResponseResultTimer.wasAccepted = false;
                    challengeResponseResultTimer.start();
                    resetValues();
                }
            }
        }

    }

    function resetValues(){
        message = defaultMessage
        challengeResponseTimer.counter = 9;
        challengeResponseTimerText.text = '9';
    }


}




