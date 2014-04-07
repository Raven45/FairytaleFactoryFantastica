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

    Connections{
        target: page
        onDoneWithFireAnimation:{
            gameOverMenu.state = "INVISIBLE";
            startMenu.state = "VISIBLE"
            clearPauseOpacity();
            backToMainMenu();
        }
    }

    Timer{
        id: leaveAfterDrawTimer
        running: false
        repeat: false
        interval: 2200
        onTriggered:{

            //since there was no fire animation, we can pretend
            doneWithFireAnimation();
        }
    }

    Timer{
        id: aiOrNetworkEndedTheGameTimer
        running: false
        repeat: false
        interval: _OPPONENT_START_ROTATION_DELAY + _CLAW_MOVE_DURATION
        onTriggered:{

            //since there was no fire animation, we can pretend
            gameOverAnimations()
        }
    }

    function gameOverAnimations(){
        //this if fixes an edge case: when you leave a game right before the AI wins, the
        //end game animations would play when the move was received

        console.log("in gameOverAnimations()");

        if( !leftSinglePlayerGameWhileAIWasMoving ){

            allGameScreenButtonsAreLocked = true;
            var winner = gameController.getWinner();

            switch( parseInt(winner) ){

            //DRAW
            case -1:
                setWinnerText("NONE");
                console.log("draw detected.");
                gameOverMenu.state = "VISIBLE";
                leaveAfterDrawTimer.start();
                break;

            //TEAL WON
            case 0:

                setWinnerText(tealPlatformCharacter);
                console.log("teal win detected.");
                gameOverMenu.state = "VISIBLE";
                killCharacter(purplePlatformCharacter);
                break;

            //PURPLE WON
            case 1:

                setWinnerText(purplePlatformCharacter);
                console.log("purple win detected.");
                gameOverMenu.state = "VISIBLE";
                killCharacter(tealPlatformCharacter);
                break;
            }
        }
    }

    Timer{
        id: networkOrAIEarlyWinGameOverAnimationsStartTimer
        interval: _OPPONENT_START_ROTATION_DELAY //time it takes the claw to place a piece
        repeat: false
        running: false

        onTriggered:{
            gameOverAnimations();
        }

    }

    function lastMoverWasAIOrNetwork(){
        return (gameController.getLastMoverColor() === (networkOrAIIsTeal? 0 : 1));
    }

    Connections {
        target: gameController
        onGameIsOver:{

            var opponentsTurn = gameController.getOpponentsTurn();

                                          //if early win (no rotation)
            if( !isVersusGame && parseInt(opponentsTurn[2]) === 111 ) {
                placeNetworkOrAIPiece( opponentsTurn[0], opponentsTurn[1] );
                networkOrAIEarlyWinGameOverAnimationsStartTimer.start();
            }

                //if draw is caused by network player
            else if( isNetworkGame && lastMoverWasAIOrNetwork() && gameController.getWinner() === -1 ){
                console.log("draw caused by network player");
                waitingOnNetworkOrAIMove = false;
                placeNetworkOrAIPiece( opponentsTurn[0], opponentsTurn[1] );
                aiOrNetworkMoveTimeout.quadrantToRotate = opponentsTurn[2];
                aiOrNetworkMoveTimeout.rotationDirection = opponentsTurn[3];
                aiOrNetworkMoveTimeout.startTimer();
                aiOrNetworkEndedTheGameTimer.start();
            }
            else if( !isVersusGame && lastMoverWasAIOrNetwork() ){
                console.log("game ended with rotation by AI or network player");
                waitingOnNetworkOrAIMove = false;
                placeNetworkOrAIPiece( opponentsTurn[0], opponentsTurn[1] );
                aiOrNetworkMoveTimeout.quadrantToRotate = opponentsTurn[2];
                aiOrNetworkMoveTimeout.rotationDirection = opponentsTurn[3];
                aiOrNetworkMoveTimeout.startTimer();
                waitingOnNetworkOrAIMove = false;
                aiOrNetworkEndedTheGameTimer.start();
            }
            else{
                gameOverAnimations();
            }

        }
    }
}
