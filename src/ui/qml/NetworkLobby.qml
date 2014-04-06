import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    id: networkLobby
    z: 101
    height: parent.height
    width: parent.width

    color: "#00FFFF"
    state: "INVISIBLE"
    property int playerCount: 0

    function challengePopupsAreHidden(){
        return challengePopup.state == "INVISIBLE" && sentChallengePopup.state == "INVISIBLE";
    }

    Text {
      id: network
      text: "Network Lobby"
      font.pointSize: 15
      font.bold: true
      anchors.top: networkLobby.top
      anchors.horizontalCenter: networkLobby.horizontalCenter
      anchors.topMargin: 5
    }



    Connections{
        target: page
        onPlayerEnteredLobby: {
            var newPlayer = arrivingPlayerName.toString();
            var playerAddress = addressOfArrivingPlayer.toString();
            var id = playerId;
            switch(playerCount){
                case 0:
                    row0.setRow(newPlayer,playerAddress,id); break;
                case 1:
                    row1.setRow(newPlayer,playerAddress,id); break;
                case 2:
                    row2.setRow(newPlayer,playerAddress,id); break;
                case 3:
                    row3.setRow(newPlayer,playerAddress,id); break;
                case 4:
                    row4.setRow(newPlayer,playerAddress,id); break;
                case 5:
                    row5.setRow(newPlayer,playerAddress,id); break;
                case 5:
                    row5.setRow(newPlayer,playerAddress,id); break;
                case 6:
                    row6.setRow(newPlayer,playerAddress,id); break;
                case 7:
                    row7.setRow(newPlayer,playerAddress,id); break;
            }

            playerCount++;
        }

        onPlayerLeftLobby:{
            playerCount--;
            console.log("Player left lobby!");

            var id = playerId;
            var foundLeavingPlayerRow = false;

            if( id == row0.getId() ){
                row0.setRow( row1.getName(),row1.getIpAddress(), row1.getId() );
                row1.clearRow();
                foundLeavingPlayerRow = true;
            }

            if( id == row1.getId() || foundLeavingPlayerRow){
                row1.setRow( row2.getName(),row2.getIpAddress(), row2.getId() );
                row2.clearRow();
                foundLeavingPlayerRow = true;
            }
            if( id == row2.getId() || foundLeavingPlayerRow){
                row2.setRow( row3.getName(),row3.getIpAddress(), row3.getId() );
                row3.clearRow();
                foundLeavingPlayerRow = true;
            }
            if( id == row3.getId() || foundLeavingPlayerRow){
                row3.setRow( row4.getName(),row4.getIpAddress(), row4.getId());
                row4.clearRow();
                foundLeavingPlayerRow = true;
            }
            if( id == row4.getId() || foundLeavingPlayerRow){
                row4.setRow( row5.getName(),row5.getIpAddress(), row5.getId());
                row5.clearRow();
                foundLeavingPlayerRow = true;
            }
            if( id == row5.getId() || foundLeavingPlayerRow){
                row5.setRow( row6.getName(),row6.getIpAddress(), row6.getId());
                row6.clearRow();
                foundLeavingPlayerRow = true;
            }
            if( id == row6.getId() || foundLeavingPlayerRow){
                row6.setRow( row7.getName(),row7.getIpAddress(), row7.getId() );
                foundLeavingPlayerRow = true;
            }

            row7.clearRow();

        }
    }


    LobbyRow{
        anchors.top: returnToMain.bottom
        id: row0
    }
    LobbyRow{
        anchors.top: row0.bottom
        id: row1
    }
    LobbyRow{
        anchors.top: row1.bottom
        id: row2
    }
    LobbyRow{
        anchors.top: row2.bottom
        id: row3
    }
    LobbyRow{
        anchors.top: row3.bottom
        id: row4
    }
    LobbyRow{
        anchors.top: row4.bottom
        id: row5
    }
    LobbyRow{
        anchors.top: row5.bottom
        id: row6
    }
    LobbyRow{
        anchors.top: row6.bottom
        id: row7
    }



    states: [
        State{
            name: "VISIBLE"
            PropertyChanges {
                target: networkLobby
                visible: true
            }

        },
        State{
            name: "INVISIBLE"
            PropertyChanges {
                target: networkLobby
                visible: false
            }
        }

    ]

    Button {
        id: returnToMain
        anchors.top: networkLobby.top
        anchors.left: networkLobby.left
        width: 100
        height: 50
        text: "Main Menu"
        onClicked: {

           if( challengePopupsAreHidden() ){
               loadingScreen.visible = true;
               networkLobby.state = "INVISIBLE";

               row0.clearRow();
               row1.clearRow();
               row2.clearRow();
               row3.clearRow();
               row4.clearRow();
               row5.clearRow();
               row6.clearRow();
               row7.clearRow();

               //need to allow others in lobby to recognize our leaving so we
               //can't reconnect quickly
               leaveLobby();
               networkLeaveLoadingTimer.start()

            }
        }
    }

    Timer{
        id: networkLeaveLoadingTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            loadingScreen.visible = false;
            startMenu.state = "VISIBLE";
            backToMainMenu();
        }

    }

    ChallengePopup{
        id: challengePopup
        anchors.centerIn: parent
    }

    SentChallengePopup{
        id: sentChallengePopup
        anchors.centerIn: parent
    }
}
