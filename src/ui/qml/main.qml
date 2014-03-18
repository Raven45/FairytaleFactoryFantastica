import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

//import GUIPlayer 1.0

Rectangle {
    id: page

    color: "#333333"

    signal readyToStartOnePersonPlay()
    signal readyToStartTwoPersonPlay()

    signal changeSoundState()
    signal changeGuiPlayerColor(int color)
    signal clickedRandomMove()
    //signal updateCurrentBoard()
    signal readyForRotation()
    signal rotationClicked( int index, int direction )
    signal rotationAnimationFinished(int quadrantRotated, int direction )
    signal placeOpponentsPiece( int qIndex, int pIndex )
    signal clearBoard()
    signal readyToExitGame()
    signal backToMainMenu()
    signal sendPlayerName(var playerName )
    signal readyToOpenClaw(int qIndex, int pIndex, var whichClaw )
    signal showPiece( int qIndex, int pIndex )
    signal turnCogs(int quadrantIndex, var direction )

    //network-related signals
    //TODO: receive challenge response
    signal enterNetworkLobby()
    signal sendThisChallenge( var stringAddressOfPlayerToChallenge )
    signal challengeReceivedFromNetwork( var challengerName, var stringAddressOfPlayerWhoChallenged )
    signal challengeWasAccepted()
    signal challengeWasDeclined()
    signal sendThisChallengeResponse( bool acceptChallenge )
    signal sendThisNetworkMove( int quadrantIndex, int pieceIndex, int quadrantToRotate, int rotationDirection )
    signal playerEnteredLobby( var arrivingPlayerName, var addressOfArrivingPlayer, int playerId )
    signal playerLeftLobby( int playerId )


    property alias main: page
    property bool guiPlayerIsWhite: false
    property bool isGuiPlayersTurn: false
    property bool guiPlayerCanClickBoardHoleButton: false
    property bool guiPlayerCanClickRotation: false
    property bool menuIsShowing: false
    property string gameMessage
    property bool isFirstMoveOfGame: true
    property bool isNetworkGame: false
    property int _ROTATION_ANIMATION_DURATION: 600
    property int _OPPONENT_START_ROTATION_DELAY: 600 + 1000 + 34*10 + 800 + 2 //claw animation time...

    property int _QUADRANT_WIDTH: 200
    property int _QUADRANT_GROWTH: 10
    property int _BOARD_HOLE_WIDTH: 65
    property int _VERTICAL_OUTSIDE: 18
    property int _VERTICAL_CENTER: 228
    property int _HORIZONTAL_TOP: -34
    property int _HORIZONTAL_CENTER: 178
    property int _CLAW_OPEN_DURATION: 350
    property int _CLAW_MOVE_DURATION: 800
    property int _CLAW_X_HOME: pentagoBoard.width/2 - 58
    property int _CLAW_Y_HOME: -300


    function lockBoardPieces(){
        guiPlayerCanClickBoardHoleButton = false;
    }

    function unlockBoardPieces(){
        console.log("unlocking board pieces and locking rotation");
        lockQuadrantRotation();
        isGuiPlayersTurn = true;
        guiPlayerCanClickBoardHoleButton = true;

    }

    function lockQuadrantRotation(){
        guiPlayerCanClickRotation = false;
    }

    function unlockQuadrantRotation(){
        if (!guiPlayerCanClickBoardHoleButton)
        {
            guiPlayerCanClickRotation = true;
        }
    }

    onBackToMainMenu:{
        isFirstMoveOfGame = true;
    }

    TextArea{
        text:gameMessage
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5
        height: 20
    }

    QmlTimer{
        id: userMoveTimeout
        duration: _ROTATION_ANIMATION_DURATION
        onTriggered:{
            //console.log("registering guiPlayer's move... ");
            gameController.registerGuiTurnWithBoard();
            lockQuadrantRotation();
            //console.log("guiPlayers turn is over.");
            isGuiPlayersTurn = false;
        }
    }

    QmlTimer{
        id: opponentsMoveTimeout
        duration: _OPPONENT_START_ROTATION_DELAY
        property int quadrantToRotate
        property int rotationDirection

        onTriggered:{
                //console.log("animating opponent rotation." );
                pentagoBoard.playRotateAnimationOnQuadrant(quadrantToRotate, rotationDirection);
                unlockGuiPiecesTimeout.startTimer();

        }
    }

    QmlTimer{
        id: unlockGuiPiecesTimeout
        duration: _ROTATION_ANIMATION_DURATION
        property int quadrantToRotate
        property int rotationDirection

        onTriggered:{

            unlockBoardPieces();
        }
    }

    onClearBoard:{
        menuIsShowing = false;
        isFirstMoveOfGame = true;

        lockQuadrantRotation();

        if (!guiPlayerIsWhite){
            lockBoardPieces();

        }
        else{

            unlockBoardPieces();

        }

    }

    Connections{
        onRotationClicked:{
            if(!menuIsShowing){
                if (guiPlayerCanClickRotation){
                    pentagoBoard.playRotateAnimationOnQuadrant( index, direction );
                    userMoveTimeout.startTimer();
                }
            }
        }

    }

    Connections{
        target: gameController
        onReadyForGuiMove:{


            var opponentsMove = gameController.getOpponentsTurn();

            if( !isFirstMoveOfGame ){
                console.log("Opponents move: " + opponentsMove);
                placeOpponentsPiece( opponentsMove[0], opponentsMove[1] );

                if( parseInt(opponentsMove[2]) !== 111 ) //DONT_ROTATE_CODE
                {
                    //console.log("telling the timer rotation data" );
                    opponentsMoveTimeout.quadrantToRotate = opponentsMove[2];
                    opponentsMoveTimeout.rotationDirection = opponentsMove[3];
                    opponentsMoveTimeout.startTimer();
                }


            }

            isFirstMoveOfGame = false;
        }

    }
    NetworkLobby{
        id:networkLobby
        anchors.centerIn: parent
    }

    SplashScreen {
        id: splash
    }

    StartMenu{
        id:startMenu
        anchors.centerIn: parent
    }
    GameOverMenu {
          id: gameOverMenu
          anchors.centerIn: page
    }
    GameScreen{
        id: gameScreen

        Board{
            id: pentagoBoard
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    function getXYOffset(quadrantIndex, pieceIndex){
        var xyOffset = { "x": 0, "y":0 };
        var distanceFromCenter = _QUADRANT_WIDTH/2 - _BOARD_HOLE_WIDTH/2;
        var xCenter;
        var yCenter;

        switch(quadrantIndex){
        case 0:
            xCenter = _VERTICAL_OUTSIDE + _QUADRANT_WIDTH/2;
            yCenter = _HORIZONTAL_TOP + _QUADRANT_WIDTH/2;
            break;
        case 1:
            xCenter = _VERTICAL_CENTER + _QUADRANT_WIDTH/2;
            yCenter = _HORIZONTAL_TOP + _QUADRANT_WIDTH/2;
            break;
        case 2:
            xCenter = _VERTICAL_OUTSIDE + _QUADRANT_WIDTH/2;
            yCenter = _HORIZONTAL_CENTER + _QUADRANT_WIDTH/2;
            break;
        case 3:
            xCenter = _VERTICAL_CENTER + _QUADRANT_WIDTH/2;
            yCenter = _HORIZONTAL_CENTER + _QUADRANT_WIDTH/2;
            break;

        }

        switch( pieceIndex ){
        case 0:
            xyOffset.x = xCenter - distanceFromCenter;
            xyOffset.y = yCenter - distanceFromCenter;
            break;
        case 1:
            xyOffset.x = xCenter;
            xyOffset.y = yCenter - distanceFromCenter;
            break;
        case 2:
            xyOffset.x = xCenter + distanceFromCenter;
            xyOffset.y = yCenter - distanceFromCenter;
            break;
        case 3:
            xyOffset.x = xCenter - distanceFromCenter;
            xyOffset.y = yCenter;
            break;
        case 4:
            xyOffset.x = xCenter;
            xyOffset.y = yCenter;
            break;
        case 5:
            xyOffset.x = xCenter + distanceFromCenter;
            xyOffset.y = yCenter;
            break;
        case 6:
            xyOffset.x = xCenter - distanceFromCenter;
            xyOffset.y = yCenter + distanceFromCenter;
            break;
        case 7:
            xyOffset.x = xCenter;
            xyOffset.y = yCenter + distanceFromCenter;
            break;
        case 8:
            xyOffset.x = xCenter + distanceFromCenter;
            xyOffset.y = yCenter + distanceFromCenter;
            break;
        }

        //console.log( " moving to x: " + xyOffset.x +" and y: " + xyOffset.y );

        return xyOffset;
    }
}
