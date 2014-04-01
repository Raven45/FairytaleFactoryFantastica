import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

//import GUIPlayer 1.0

Rectangle {
    id: page
    height: 900
    width:1440

    color: "#333333"

    signal droppedSomethingInOven()
    signal readyToStartOnePersonPlay( int aiLevel )
    signal readyToStartTwoPersonPlay()
    signal load()
    signal hanselIsOverOven()
    signal gretelIsOverOven()
    signal startPickUpHansel()
    signal startPickUpGretel()
    signal clawHasHansel()
    signal clawHasGretel()

    signal clawMovingUp()
    signal clawMovingDown()
    signal finishedClawMovingY()
    signal makeRightCanGoBack()
    signal resetRightCan()
    signal changeSoundState()
    signal changeGuiPlayerColor(int color)
    signal clickedRandomMove()
    signal readyForRotation()
    signal rotationClicked( int index, int direction )
    signal rotationAnimationFinished(int quadrantRotated, int direction )
    signal placeOpponentsPiece( int qIndex, int pIndex )
    signal clearBoard()
    signal readyToExitGame()
    signal backToMainMenu()
    signal sendPlayerName(var playerName )
    signal readyToOpenClaw(int qIndex, int pIndex, var whichClaw )
    signal getFromCan( var whichClaw )
    signal showPiece( int qIndex, int pIndex )
    signal turnCogs(int quadrantIndex, var direction )
    signal pauseOpacity()
    signal clearPauseOpacity()
    signal pieceFlowIntensityChanged( int volume )
    signal playRotateAnimationOnQuadrant(int quadrantToRotate, int rotationDirection)
    signal startGumdropAnimation()
    signal pauseGumdropAnimation()
    signal resumeGumdropAnimation()
    signal resetGumdropAnimation()
    signal leaveGumdropAnimation()

    //network-related signals
    signal enterNetworkLobby()
    signal sendThisChallenge( var stringAddressOfPlayerToChallenge )
    signal challengeReceivedFromNetwork( var challengerName, var stringAddressOfPlayerWhoChallenged )
    signal challengeWasAccepted()
    signal challengeWasDeclined()
    signal sendThisChallengeResponse( bool acceptChallenge )
    signal sendThisNetworkMove( int quadrantIndex, int pieceIndex, int quadrantToRotate, int rotationDirection )
    signal playerEnteredLobby( var arrivingPlayerName, var addressOfArrivingPlayer, int playerId )
    signal playerLeftLobby( int playerId )
    signal opponentDisconnected()
    signal opponentReconnected()
    signal startPieceAnimations()
    signal spreadIcing(int qIndex, int pIndex)
    signal gateOpened()


    property alias main: page
    property bool guiPlayerIsWhite: false
    property bool isGuiPlayersTurn: false
    property bool guiPlayerCanClickBoardHoleButton: false
    property bool guiPlayerCanClickRotation: false
    property bool menuIsShowing: false
    property string gameMessage
    property bool isFirstMoveOfGame: true
    property bool isNetworkGame: false
    property bool piecesHaveStartedAnimating: false

    property bool _SOUND_CHECK_FLAG: false

    property int _SPREAD_DURATION: 800
    property int _ROTATION_ANIMATION_DURATION: 800
    property int _OPPONENT_START_ROTATION_DELAY: 300 + _CLAW_OPEN_DURATION + _CLAW_MOVE_DURATION + _CLAW_CAN_ANIMATION_DURATION + 2 //claw animation time...
    property int _QUADRANT_WIDTH: 200
    property double _QUADRANT_GROWTH: 1.3
    property int _BOARD_HOLE_WIDTH: 65
    property int _VERTICAL_OUTSIDE: 18
    property int _VERTICAL_CENTER: 230
    property int _HORIZONTAL_TOP: -30
    property int _HORIZONTAL_CENTER: 182
    property int _CLAW_OPEN_DURATION: 350
    property int _CLAW_MOVE_DURATION: 800
    property int _CLAW_X_TO_CAN_DURATION: 400
    property int _CLAW_Y_TO_CAN_DURATION: 400
    property int _CLAW_PAUSE_OVER_CAN_BEFORE_DURATION: 275
    property int _CLAW_MOVE_INTO_CAN_DURATION: 300
    property int _CLAW_TIME_IN_CAN_DURATION: 300
    property int _CLAW_MOVE_OUT_OF_CAN_DURATION: _CLAW_MOVE_INTO_CAN_DURATION
    property int _CLAW_PAUSE_OVER_CAN_AFTER_DURATION: _CLAW_PAUSE_OVER_CAN_BEFORE_DURATION
    property int _CLAW_CAN_ANIMATION_DURATION: _CLAW_X_TO_CAN_DURATION + _CLAW_Y_TO_CAN_DURATION + _CLAW_PAUSE_OVER_CAN_BEFORE_DURATION + _CLAW_MOVE_INTO_CAN_DURATION + _CLAW_TIME_IN_CAN_DURATION + _CLAW_MOVE_OUT_OF_CAN_DURATION + _CLAW_PAUSE_OVER_CAN_AFTER_DURATION + 50
    property int _CLAW_X_HOME: 900
    property int _CLAW_Y_HOME: -180
    property int _RIGHT_CAN_X: 815
    property int _CAN_HEIGHT: 160
    property int _RIGHT_CAN_Y: 300
    property int _LEFT_CAN_X: -325
    property int _LEFT_CAN_Y: _RIGHT_CAN_Y
    property int _CLAW_HOUSE_Y_OFFSET: -25
    property int _CLAW_SPRITE_WIDTH: 131
    property int _CLAW_HOUSE_X_OFFSET: -23
    property int _CLAW_HOUSE_X_MOVE_WHEN_SHRINKING: 27
    property int _SPELL_X_OFFSET: 60
    property int _SPELL_Y_OFFSET: 110

    Rectangle{
        id: menuFade
        anchors.fill: parent
        z: 600
        color: "black"
        opacity: 0;

        Behavior on opacity{
            NumberAnimation { duration: 1800 }
        }
    }

    function changeSoundCheckFlag() {
        if( _SOUND_CHECK_FLAG ) {
            _SOUND_CHECK_FLAG = false;
        } else {
            _SOUND_CHECK_FLAG = true;
        }
    }
    
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
        //deprecated and invisible - should probably get rid of. leaving in case we need it.
        text:gameMessage
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5
        height: 20
        visible: false
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
                playRotateAnimationOnQuadrant(quadrantToRotate, rotationDirection);
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
                    playRotateAnimationOnQuadrant( index, direction );
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

    GenericPopup{
        id: networkPlayerDisconnectedPopup
        message: "Connection lost. Waiting for reconnect..."
        hideButton2: true
        anchors.centerIn: page
        z: 400
        button1Text: "Leave Game"

        QmlTimer{
            id: reconnectSuccessTimer
            duration: 1000
            onTriggered:{
                networkPlayerDisconnectedPopup.state = "INVISIBLE";
                networkPlayerDisconnectedPopup.message = "Connection lost. Waiting for reconnect...";
                networkPlayerDisconnectedPopup.enableButton1();
            }
        }

        Connections{
            target: page
            onOpponentDisconnected:{
                if( startMenu.state == "INVISIBLE" && networkLobby.state == "INVISIBLE" && isNetworkGame ){
                    networkPlayerDisconnectedPopup.state = "VISIBLE";
                }
            }

            onOpponentReconnected:{
                if( startMenu.state == "INVISIBLE" && networkLobby.state == "INVISIBLE" && isNetworkGame ){
                    networkPlayerDisconnectedPopup.disableButton1();
                     networkPlayerDisconnectedPopup.message = "Connection reestablished!"
                    reconnectSuccessTimer.startTimer();
                }
            }
        }

        onButton1Clicked: {
            state = "INVISIBLE";
            startMenu.state = "VISIBLE";
            clearBoard();
            backToMainMenu();
        }
    }

    Rectangle{
        id: loadingScreen
        visible: true
        z: 999
        anchors.fill: parent
        color: "black"

        Text{

            anchors.centerIn: parent
            font.pointSize: 40
            color: "white"
            text: "Loading..."
        }

        Timer{
            interval: 4000
            repeat: false
            running: true

            onTriggered:{
                musicPlayer.togglePlayback();
                _SOUND_CHECK_FLAG = true;
                splash.visible = true;
                loadingScreen.visible = false;
                load()
            }
        }
    }

    MusicPlayer{
        id: musicPlayer
    }

    SplashScreen {
        id: splash
    }

    StartScreen{
        id:startScreen
        anchors.centerIn: parent
    }

    ForkliftMenu{
        id:startMenu
        anchors.centerIn: parent
        z: 100
    }
    GameOverMenu {
          id: gameOverMenu
          anchors.centerIn: page
    }
    GameScreen{
        id: gameScreen
        z:1
    }

	HelpScreen {
		id: help
		visible: false
		width: page.width
		height: page.height
		anchors.centerIn: page
		z: 900
        color: "#88000000"
        //color: "black"
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
