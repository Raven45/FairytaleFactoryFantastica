import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {

    property int playerId: 0

    function getName(){
        return myName_text.text;
    }

    function getId(){
        return playerId;
    }

    function getIpAddress(){
        return myAddress_text.text;
    }

    function getBusyStatus(){
        return challengePlayer.text == "Busy...";
    }

    visible: false
    anchors.left: net_brick_background.left
    anchors.leftMargin: 138

    FontLoader{ id: monoSpacedFont; source: "DejaVuSansMono.ttf" }

    Rectangle{
        id: myName
        anchors.left: parent.left
        anchors.leftMargin: 76
        width: 80; height: 25
        color: "transparent"

        Text {
            id: myName_text
            anchors.left: myName.left
            anchors.verticalCenter: myName.verticalCenter
            font{ family: monoSpacedFont.name; pointSize: 10 }
            text: ""
        }
    }
    
    Connections{
         target: page
         onNetworkPlayerNoLongerBusy:{
             var address = addressVariant.toString();

             if( address === getIpAddress() ){
                challengePlayer.text = "Challenge!"
                 console.log("lobby row: " + address + " is no longer busy")
                challengePlayer.enabled = true;
             }

         }

         onNetworkPlayerBecameBusy:{
             var address = addressVariant.toString();

             console.log( "address format in gui: " + address );

             if( address === getIpAddress() ) {
                challengePlayer.text = "Busy..."
                console.log("lobby row: " + address + " became busy")
                challengePlayer.enabled = false;
             }
         }
     }

     Rectangle{
         id: myAddress
         anchors.left: myName.right
         width: 373; height: 25
         color: "transparent"

         Text {
             id: myAddress_text
             anchors.centerIn: myAddress
             font{ family: monoSpacedFont.name; pointSize: 10 }
             text: ""
         }
     }

     Rectangle {
         id: challengePlayer
         width: 95; height: 25
         anchors.left: myAddress.right
         anchors.leftMargin: -65
         visible: false;
         color: "yellow"
         border.color: "black"

         Text {
             id: challengePlayer_text
             anchors.centerIn: challengePlayer
             font{ family: monoSpacedFont.name; pointSize: 10 }
             text: "Ready"
         }

         MouseArea{
             id: challengePlayer_mouseArea
             anchors.fill: challengePlayer
             hoverEnabled: true

             onEntered:{
                 if(challengePopupsAreHidden() && challengePlayer_text.text == "Ready"){
                    challengePlayer_text.text = "Challenge!";
                    challengePlayer_text.color = "white";
                    challengePlayer.color = "green";
                 }
             }
             onExited: {
                 if(challengePopupsAreHidden() && challengePlayer_text.text == "Challenge!"){
                     challengePlayer_text.text = "Ready";
                     challengePlayer_text.color = "black";
                     challengePlayer.color = "yellow";
                 }
             }
             onClicked: {
                 if( challengePopupsAreHidden() ){
                     sendThisChallenge( myAddress_text.text );
                 }
             }
         }
     }

     function setRow(newPlayer, playerAddress, idToSet, isBusy ){
         myName_text.text = newPlayer;
         myAddress_text.text = playerAddress;
         playerId = idToSet;
         challengePlayer.enabled = !isBusy;
         challengePlayer.text = isBusy? "Busy..." : "Challenge!";

         if( playerId != 0 ){
             challengePlayer.visible = true;
         }
         else{
             challengePlayer.visible = false;
         }

         visible = true;
     }

     function clearRow(){
         myName_text.text = "";
         myAddress_text.text = "";
         challengePlayer.visible = false;
         challengePlayer_text.text = "Ready";
         challengePlayer_text.color = "black";
         challengePlayer.color = "yellow";
         playerId = 0;
         visible = false;
     }
}
