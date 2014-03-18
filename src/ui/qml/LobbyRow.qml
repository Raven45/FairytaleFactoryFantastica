import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {

    property int playerId: 0

    function getName(){
        return myName.text;
    }

    function getId(){
        return playerId;
    }

    function getIpAddress(){
        return myAddress.text;
    }

    visible: false
    anchors.topMargin: 30
    anchors.left: networkLobby.left
    anchors.leftMargin: 20



     Text {
         id: myName
         anchors.left: parent.left
         width: 250
         text: ""
     }
     Text {
         anchors.left: myName.right
         id: myAddress
         width: 250
         text: ""
     }

     Button {
         anchors.left: myAddress.right
         id: challengePlayer
         visible: false;
         text: "Challenge!"
         onClicked: {

             if( challengePopupsAreHidden() ){
                 sendThisChallenge( myAddress.text );
             }

         }

     }

     function setRow(newPlayer, playerAddress, idToSet ){
         myName.text = newPlayer;
         myAddress.text = playerAddress;
         playerId = idToSet;

         if( playerId != 0 ){
             challengePlayer.visible = true;
         }
         else{
             challengePlayer.visible = false;
         }

         visible = true;
     }

     function clearRow(){
         myName.text = "";
         myAddress.text = "";
         challengePlayer.visible = false;
         challengePlayer.text = "Challenge!";
         playerId = 0;
         visible = false;
     }
}
