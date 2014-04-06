import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: gameOverMenu
    z: 200
    width: 1440
    height: 200
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 0 - height

    state: "INVISIBLE"

    states:[
        State{
            name: "VISIBLE"
            PropertyChanges{
                target: gameOverMenu.anchors
                topMargin: 0
            }
        },
        State{
            name: "INVISIBLE"
            PropertyChanges{
                target: gameOverMenu.anchors
                topMargin: 0 - gameOverMenu.height
            }
        }
    ]

    transitions:[
        Transition{
            from: "*"
            to:"*"
            NumberAnimation {target: gameOverMenu.anchors; properties: "topMargin"; easing.type: Easing.InCirc; duration: 1000}
        }
    ]

    Image{
        id: gameOverPlate
        z:1
        width: parent.width
        height: parent.height
        anchors.centerIn: gameOverMenu
        source: "gameOverPlate.png"
    }
    Image{
        id: hanselWinsText
        visible: false
        z: 2
        width: parent.width
        height: parent.height
        anchors.centerIn: gameOverMenu
        source: "hanselWins.png"
    }
    Image{
        id: gretelWinsText
        visible: false
        z: 2
        width: parent.width
        height: parent.height
        anchors.centerIn: gameOverMenu
        source: "gretelWins.png"
    }
    Image{
        id: witchWinsText
        visible: false
        z: 2
        width: parent.width
        height: parent.height
        anchors.centerIn: gameOverMenu
        source: "witchWins.png"
    }
    Image{
        id: drawText
        visible: false
        z: 2
        width: parent.width
        height: parent.height
        anchors.centerIn: gameOverMenu
        source: "tieText.png"
    }

    function setWinnerText( winningCharacter ){

        console.log("in setWinnerText, winningCharacter = " + winningCharacter);

        hanselWinsText.visible = false;
        gretelWinsText.visible = false;
        witchWinsText.visible = false;
        drawText.visible = false;

        if( winningCharacter == "hansel"){
            hanselWinsText.visible = true;
        }
        else if( winningCharacter == "gretel"){
            gretelWinsText.visible = true;
        }
        else if( winningCharacter == "witch"){
            witchWinsText.visible = true;
        }
        else if( winningCharacter == "NONE"){
            drawText.visible = true;
        }
    }

    Timer{
        id: leaveGameScreenTimer
        interval: 15000
        repeat: false
        running: false
        onTriggered:{
            gameOverMenu.state = "INVISIBLE";
            startMenu.state = "VISIBLE"
            clearPauseOpacity();
            backToMainMenu();
        }
    }

    QmlTimer {
        duration: _OPPONENT_START_ROTATION_DELAY + _ROTATION_ANIMATION_DURATION
        id: gameOverTimeout
        property string loser: "NONE"
        onTriggered: {
            killCharacter(loser);
            lockBoardPieces()
            lockQuadrantRotation()
            gameOverMenu.state = "VISIBLE";
            allGameScreenButtonsAreLocked = true;
        }
    }

    function gameOverAnimations(){
        //this if fixes an edge case: when you leave a game right before the AI wins, the
        //end game animations would play when the move was received
        if( !leftSinglePlayerGameWhileAIWasMoving ){

            allGameScreenButtonsAreLocked = true;

            var winner = gameController.getWinner();

            leaveGameScreenTimer.start();

            switch( parseInt(winner) ){

            //DRAW
            case -1:
                setWinnerText("NONE");
                console.log("draw detected.");
                break;

            //TEAL WON
            case 0:

                setWinnerText(tealPlatformCharacter);
                console.log("teal win detected.");

                if( isVersusGame || !networkOrAIIsTeal ){
                    gameOverMenu.state = "VISIBLE";
                    killCharacter(purplePlatformCharacter);
                }
                else{
                    gameOverTimeout.loser = purplePlatformCharacter;
                    gameOverTimeout.startTimer();
                }

                break;

            //PURPLE WON
            case 1:

                setWinnerText(purplePlatformCharacter);
                console.log("purple win detected.");

                if(  isVersusGame || networkOrAIIsTeal ){
                    gameOverMenu.state = "VISIBLE";
                    killCharacter(tealPlatformCharacter);
                }
                else{
                    gameOverTimeout.loser = tealPlatformCharacter;
                    gameOverTimeout.startTimer();
                }

                break;
            }
        }
    }

    Timer{
        id: networkEarlyWinGameOverAnimationsStartTimer
        interval: _OPPONENT_START_ROTATION_DELAY //time it takes the claw to place a piece
        repeat: false
        running: false

        onTriggered:{
            gameOverAnimations();
        }

    }

    Connections {
        target: gameController
        onGameIsOver:{
            if( isNetworkGame ) {

                var opponentsTurn = gameController.getOpponentsTurn();

                //if early win (no rotation)
                if( parseInt(opponentsTurn[2]) === 111 ) {
                    placeNetworkOrAIPiece( opponentsTurn[0], opponentsTurn[1] );
                    networkEarlyWinGameOverAnimationsStartTimer.start();
                }
            }
            else{
                gameOverAnimations();
            }

        }
    }
}
