import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: parentRow
    anchors.topMargin: 30
    state: "READY"

    states:[
        State{
            name: "BUSY"
            PropertyChanges {
                target: challengePlayer
                color: "red"
                visible: true
                enabled: false

            }

            PropertyChanges {
                target: challengePlayer_text
                color: "white"
                text: "Busy..."
            }
        },
        State{
            name: "DISABLED"
            PropertyChanges {
                target: challengePlayer
                visible: false
                enabled: false

            }
        },
        State{
            name: "READY"
            PropertyChanges {
                target: challengePlayer
                color: "yellow"
                visible: true
                enabled: true

            }

            PropertyChanges {
                target: challengePlayer_text
                color: "black"
                text: "Ready"
            }
        },
        State{
            name: "CHALLENGE"
            PropertyChanges {
                target: challengePlayer
                visible: true
                color: "green"
                enabled: true
            }
            PropertyChanges {
                target: challengePlayer_text
                color: "white"
                text: "Challenge!"
            }
        }

    ]



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
        return state == "BUSY";
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
                parentRow.state = "READY";
                 console.log("lobby row: " + address + " is no longer busy")
                challengePlayer.enabled = true;
             }

         }

         onNetworkPlayerBecameBusy:{
             var address = addressVariant.toString();

             console.log( "address format in gui: " + address );

             if( address === getIpAddress() ) {
                parentRow.state = "BUSY"
                console.log("lobby row: " + address + " became busy")
                challengePlayer.enabled = false;
             }
         }

         onNetClockAnimationStarted:{
            parentRow.state = "DISABLED";
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
         property bool enabled: true
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
                 if(challengePopupsAreHidden() && parentRow.state == "READY" && challengePlayer.enabled ){
                    parentRow.state = "CHALLENGE";
                 }
             }
             onExited: {
                 if(challengePopupsAreHidden() && parentRow.state == "CHALLENGE" && challengePlayer.enabled ){
                     parentRow.state = "READY";
                 }
             }
             onClicked: {
                 if( challengePopupsAreHidden() && challengePlayer.enabled ){
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
         state = isBusy? "BUSY" : "READY"

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
         state = "READY"
         playerId = 0;
         visible = false;
     }
}
