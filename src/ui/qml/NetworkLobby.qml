import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    id: networkLobby
    z: 101
    height: parent.height
    width: parent.width
    color: "transparent"

    state: "INVISIBLE"
    property int playerCount: 0

    function challengePopupsAreHidden(){
        return challengePopup.state == "INVISIBLE" && sentChallengePopup.state == "INVISIBLE";
    }

    function getOutOfHere(){
        networkLobby.state = "INVISIBLE";

        //need to allow others in lobby to recognize our leaving so we
        //can't reconnect quickly
        leaveLobby();
        networkLeaveLoadingTimer.start();
    }

    SequentialAnimation{
        id: net_clock_animation
        running: false

        ParallelAnimation{
            NumberAnimation{ target: net_card; property: "y"; from: net_card.y; to: net_card.y - 250; duration: 800; easing.type: Easing.InOutQuad }
            NumberAnimation{ target: net_card; property: "x"; from: net_card.x; to: net_card.x - 294; duration: 800; easing.type: Easing.InOutQuad }
        }
        //Just makes it disappear. WHY?! WHY!!!
        //PropertyAction { target: net_card; property: "z"; value: "net_dummy_rec.z"  }
        NumberAnimation{ target: net_card; property: "y"; from: net_card.y - 250; to: net_card.y - 175; duration: 400; easing.type: Easing.OutInQuad }
        NumberAnimation{ target: net_card; property: "y"; from: net_card.y - 175; to: net_card.y - 250; duration: 400; easing.type: Easing.OutInQuad }
        //PropertyAction { target: net_card; property: "z"; value: "net_punch_cards.z + 1" }
        ParallelAnimation{
            NumberAnimation{ target: net_card; property: "y"; to: net_card.y; from: net_card.y - 250; duration: 800; easing.type: Easing.InOutQuad }
            NumberAnimation{ target: net_card; property: "x"; to: net_card.x; from: net_card.x - 294; duration: 800; easing.type: Easing.InOutQuad }
        }

        onStopped:{ getOutOfHere(); }
    }

    Rectangle{
        id: net_dummy_rec
        width: 10; height: 10
        color: "transparent"
        z: net_clock_img.z + 5

        anchors.top: networkLobby.bottom
        anchors.topMargin: -10
        anchors.left: networkLobby.left
        anchors.leftMargin: -10
    }

    Rectangle{
        id: net_clock
        width: net_clock_img.width * net_clock_img.scale
        height: net_clock_img.height * net_clock_img.scale
        z: net_brick_background.z + 1
        anchors.right: net_punch_cards.left
        anchors.rightMargin: -75
        anchors.verticalCenter: networkLobby.verticalCenter
        color: "transparent"

        Rectangle{
            id: net_clock_slot_back
            width: (net_clock_img.width * net_clock_img.scale)/3 + 10
            height: 5
            color: "black"
            z: net_clock_img.z + 1

            anchors.top: net_clock_img.top
            anchors.topMargin: 105
            anchors.horizontalCenter: net_clock.horizontalCenter
            anchors.horizontalCenterOffset: 2
        }

        Rectangle{
            id: net_clock_slot_front
            width: (net_clock_img.width * net_clock_img.scale)/3 + 10
            height: 10
            color: "black"
            z: net_clock_img.z + 5

            anchors.top: net_clock_slot_back.bottom
            anchors.horizontalCenter: net_clock.horizontalCenter
            anchors.horizontalCenterOffset: 2
        }

        Image{
            id: net_clock_front_img
            source: "net-clock-front.png"
            width: 400; height: 400
            fillMode: Image.PreserveAspectFit
            scale: 0.6
            z: net_clock_img.z + 5
            anchors.centerIn: net_clock
        }

        Image{
            id: net_clock_img
            source: "net-clock.png"
            width: 400; height: 400
            fillMode: Image.PreserveAspectFit
            scale: 0.6
            z: net_clock.z + 1
            anchors.centerIn: net_clock
        }
    }

    Image{
        id: net_punch_cards
        source: "net-punch-cards.png"
        width: 500; height: 500
        fillMode: Image.PreserveAspectFit
        scale: 0.6 //300x300
        z: net_brick_background.z + 1
        anchors.right: networkLobby.right
        anchors.rightMargin: -120
        anchors.verticalCenter: networkLobby.verticalCenter
    }

    Image{
        id: net_card
        source: "net-card.png"
        width: 300; height: 300
        fillMode: Image.PreserveAspectFit
        scale: 0.6
        z: net_punch_cards.z + 1

        x: (net_sleve.x - ((net_card.width  * net_card.scale)/2)) + 85
        y: (net_sleve.y - ((net_card.height * net_card.scale)/2)) + 15

        /*
        anchors.bottom: net_punch_cards.bottom
        anchors.bottomMargin: 32
        anchors.horizontalCenter: net_punch_cards.horizontalCenter
        anchors.horizontalCenterOffset: 1
        */
    }

    Image{
        id: net_sleve
        source: "net-sleve.png"
        width: 300; height: 200
        fillMode: Image.PreserveAspectFit
        scale: 0.6
        z: net_punch_cards.z + 2
        anchors.bottom: net_punch_cards.bottom
        anchors.bottomMargin: 60
        anchors.horizontalCenter: net_punch_cards.horizontalCenter
        anchors.horizontalCenterOffset: 2
    }

    Image{
        id: net_brick_background
        source: "net-brick-background.png"
        width: 1440; height: 900
        anchors.fill: networkLobby
        anchors.centerIn: networkLobby
        fillMode: Image.PreserveAspectCrop
        z: networkLobby.z + 1
    }

    Image{
        id: net_clip_lobby
        source: "net-clip-lobby-3.png"
        width: 800; height: 900
        z: net_brick_background.z + 1
        fillMode: Image.PreserveAspectFit

        anchors.left: networkLobby.left
        anchors.leftMargin: 50
        anchors.verticalCenter: networkLobby.verticalCenter
    }

    Image {
        id: exitNetworkLobby
        source: "exitButton.png"
        width: 100; height: 100;
        z: net_brick_background.z + 1
        anchors.left: networkLobby.left
        anchors.leftMargin: 20
        anchors.bottom: networkLobby.bottom
        anchors.bottomMargin: 20
        visible: true
        MouseArea {
            anchors.fill: parent
            onClicked:{
                if( challengePopupsAreHidden() ){
                    net_clock_animation.start()
                 }
            }
        }
    }

    /*
    Text {
      id: network
      text: "Network Lobby"
      font.pointSize: 15
      font.bold: true
      anchors.top: networkLobby.top
      anchors.horizontalCenter: networkLobby.horizontalCenter
      anchors.topMargin: 5
    }
    */


    Connections{
        target: page

        onBackToMainMenu:{

            if( isNetworkGame ){
                leaveLobby();
                row0.clearRow();
                row1.clearRow();
                row2.clearRow();
                row3.clearRow();
                row4.clearRow();
                row5.clearRow();
                row6.clearRow();
                row7.clearRow();
            }
        }

        onPlayerEnteredLobby: {
            var newPlayer = arrivingPlayerName.toString();
            var playerAddress = addressOfArrivingPlayer.toString();
            var id = playerId;
            switch(playerCount){
                case 0:
                    row0.setRow(newPlayer,playerAddress,id, isBusy ); break;
                case 1:
                    row1.setRow(newPlayer,playerAddress,id, isBusy ); break;
                case 2:
                    row2.setRow(newPlayer,playerAddress,id, isBusy ); break;
                case 3:
                    row3.setRow(newPlayer,playerAddress,id, isBusy ); break;
                case 4:
                    row4.setRow(newPlayer,playerAddress,id, isBusy ); break;
                case 5:
                    row5.setRow(newPlayer,playerAddress,id, isBusy ); break;
                case 5:
                    row5.setRow(newPlayer,playerAddress,id, isBusy ); break;
                case 6:
                    row6.setRow(newPlayer,playerAddress,id, isBusy ); break;
                case 7:
                    row7.setRow(newPlayer,playerAddress,id, isBusy ); break;
            }

            playerCount++;
        }

        onPlayerLeftLobby:{
            playerCount--;
            console.log("Player left lobby!");

            var id = playerId;
            var foundLeavingPlayerRow = false;

            if( id == row0.getId() ){
                row0.setRow( row1.getName(),row1.getIpAddress(), row1.getId(), row1.getBusyStatus() );
                row1.clearRow();
                foundLeavingPlayerRow = true;
            }

            if( id == row1.getId() || foundLeavingPlayerRow){
                row1.setRow( row2.getName(),row2.getIpAddress(), row2.getId(), row2.getBusyStatus() );
                row2.clearRow();
                foundLeavingPlayerRow = true;
            }
            if( id == row2.getId() || foundLeavingPlayerRow){
                row2.setRow( row3.getName(),row3.getIpAddress(), row3.getId(), row3.getBusyStatus() );
                row3.clearRow();
                foundLeavingPlayerRow = true;
            }
            if( id == row3.getId() || foundLeavingPlayerRow){
                row3.setRow( row4.getName(),row4.getIpAddress(), row4.getId(), row4.getBusyStatus() );
                row4.clearRow();
                foundLeavingPlayerRow = true;
            }
            if( id == row4.getId() || foundLeavingPlayerRow){
                row4.setRow( row5.getName(),row5.getIpAddress(), row5.getId(), row5.getBusyStatus() );
                row5.clearRow();
                foundLeavingPlayerRow = true;
            }
            if( id == row5.getId() || foundLeavingPlayerRow){
                row5.setRow( row6.getName(),row6.getIpAddress(), row6.getId(), row6.getBusyStatus() );
                row6.clearRow();
                foundLeavingPlayerRow = true;
            }
            if( id == row6.getId() || foundLeavingPlayerRow){
                row6.setRow( row7.getName(),row7.getIpAddress(), row7.getId(), row7.getBusyStatus() );
                foundLeavingPlayerRow = true;
            }

            row7.clearRow();

        }
    }


    LobbyRow{
        id: row0
        anchors.top: net_clip_lobby.top
        anchors.topMargin: 249
        anchors.left: net_brick_background.left
        anchors.leftMargin: 138
        z: net_clip_lobby.z + 1
    }
    LobbyRow{
        anchors.top: row0.bottom
        id: row1
        z: net_clip_lobby.z + 1
    }
    LobbyRow{
        anchors.top: row1.bottom
        id: row2
        z: net_clip_lobby.z + 1
    }
    LobbyRow{
        anchors.top: row2.bottom
        id: row3
        z: net_clip_lobby.z + 1
    }
    LobbyRow{
        anchors.top: row3.bottom
        id: row4
        z: net_clip_lobby.z + 1
    }
    LobbyRow{
        anchors.top: row4.bottom
        id: row5
        z: net_clip_lobby.z + 1
    }
    LobbyRow{
        anchors.top: row5.bottom
        id: row6
        z: net_clip_lobby.z + 1
    }
    LobbyRow{
        anchors.top: row6.bottom
        id: row7
        z: net_clip_lobby.z + 1
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

    /*
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



               //need to allow others in lobby to recognize our leaving so we
               //can't reconnect quickly
               leaveLobby();
               networkLeaveLoadingTimer.start()

            }
        }
    }
    */

    Timer{
        id: networkLeaveLoadingTimer
        interval: 500
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
