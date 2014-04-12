import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtMultimedia 5.0

//import GUIPlayer 1.0

Rectangle {
    id: page
    //height: 900
    //width:1440

    color: "#333333"

    signal networkPlayerBecameBusy( var addressVariant )
    signal networkPlayerNoLongerBusy(var addressVariant )
    signal leaveForkliftMenuToGameScreen()
    signal doneWithFireAnimation()
    signal placeCharacterOnPlatform( string character, string platform );
    signal droppedSomethingInOven()
    signal readyToStartOnePersonPlay( int aiLevel, int menuSelectedColor )
    signal readyToStartTwoPersonPlay()
    signal load()
    signal startRotationOnRedRotationButtons()
    signal hanselIsOverOven()
    signal gretelIsOverOven()
    signal witchIsOverOven()
    signal startPickUpHansel()
    signal startPickUpGretel()
    signal startPickUpWitch()
    signal clawHasHansel()
    signal clawHasGretel()
    signal clawHasWitch()
    signal clawMovingUp()
    signal clawMovingDown()
    signal finishedClawMovingY()
    signal makeRightCanGoBack()
    signal resetRightCan()
    signal changeSoundState()
    signal changeGuiPlayerColor(int color)
    signal clickedRandomMove()
    signal readyForUserToClickRotation()
    signal rotationLegallyClicked( int index, int direction )
    signal rotationAnimationFinished(int quadrantRotated, int direction )
    signal placeNetworkOrAIPiece( int qIndex, int pIndex )
    signal clearBoard()
    signal readyToExitGame()
    signal backToMainMenu()
    signal leaveLobby()
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
    signal playerEnteredLobby( var arrivingPlayerName, var addressOfArrivingPlayer, int playerId, bool isBusy )
    signal playerLeftLobby( int playerId )
    signal opponentDisconnected()
    signal opponentReconnected()
    signal startPieceAnimations()
    signal spreadIcing(int qIndex, int pIndex)
    signal gateOpened()


    property alias main: page
    property bool appropriateTimeToQuit: false
    property bool waitingOnAnimationsToFinishSoWeCanLeaveGameScreen: false
    property bool movingPlayerIsTeal: false
    property bool waitingForAnimationsToFinish: false
    property bool waitingForAISoWeCanExitGame: false
    property bool movingPlayerIsNetworkOrAI: false
    property bool leftSinglePlayerGameWhileAIWasMoving: false
    property bool networkOrAIIsTeal: false
    property string tealPlatformCharacter: "NONE"
    property string purplePlatformCharacter: "NONE"
    property bool guiPlayerCanClickBoardHoleButton: false
    property bool guiPlayerCanClickRotation: false
    property bool allGameScreenButtonsAreLocked: true
    property bool forkliftMenuButtonsAreLocked: false
    property string gameMessage

    property bool isSinglePlayerGame: false
    property bool isVersusGame: false
    property bool isNetworkGame: false

    property bool piecesHaveStartedAnimating: false
    property bool waitingOnNetworkOrAIMove: false
    property bool _SOUND_CHECK_FLAG: false

    property bool startOnePlayer_currently_selected: false
    property bool pvp_currently_selected: false
    property bool net_currently_selected: false

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

    GenericPopup {
        id: escKeyPopup
        anchors.left: parent.left
        anchors.leftMargin: (parent.width / 2) - (escKeyPopup.width/2)
        anchors.verticalCenter: parent.verticalCenter
        z: 999 //Any z value greater than this? Hopefully not.

        visible: false
        message: "Would you like to Quit?"
        button1Text: "No"
        onButton1Clicked: escKeyPopup.visible = false;
        button2Text: "Quit"
        onButton2Clicked: readyToExitGame();
    }

    Item {
        id: escKeyQuit
        anchors.fill: parent
        focus: false
        Keys.onEscapePressed: { escIfAppropriate(); }
    }

    Item {
        id: dummyKeyDummy
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: {
            console.log("dummyKeyDummy gots focus!");
        }
    }

    function escIfAppropriate() {
        if(appropriateTimeToQuit){ escKeyPopup.visible = true; }
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

    onLeaveForkliftMenuToGameScreen:{

        if( !piecesHaveStartedAnimating ){
            startPieceAnimations();
            piecesHaveStartedAnimating = true;

        } else{
            resumeGumdropAnimation();
        }

        clearBoard();
        movingPlayerIsTeal = true;
        leftSinglePlayerGameWhileAIWasMoving = false;
        allGameScreenButtonsAreLocked = false;
        startMenu.state = "INVISIBLE";
    }

    function killCharacter( character ){
        if( character == "witch" ){
            startPickUpWitch();
        }
        else if ( character == "hansel" ){
            startPickUpHansel();
            if(_SOUND_CHECK_FLAG) witchSound.play();
        }
        else if ( character == "gretel" ){
            startPickUpGretel();
            if(_SOUND_CHECK_FLAG) witchSound.play();
        }
        else{
            console.log("in main.qml function killCharacter: invalid parameter");
        }
    }

    function unlockBoardPieces(){
        console.log("unlocking board pieces and locking rotation");
        lockQuadrantRotation();
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
            console.log("guiPlayers turn is over.");

            movingPlayerIsTeal = !movingPlayerIsTeal;



            if( isSinglePlayerGame || isNetworkGame ){
                movingPlayerIsNetworkOrAI = true;
            }
            else if ( isVersusGame ){
                unlockBoardPieces();
            }
        }
    }

    SoundEffect {
        id: witchSound
        source: "witch-laugh.wav"
    }

    QmlTimer{
        id: aiOrNetworkMoveTimeout
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
            movingPlayerIsTeal = !movingPlayerIsTeal;
            unlockBoardPieces();
        }
    }

    onClearBoard:{
        allGameScreenButtonsAreLocked = false;
        movingPlayerIsTeal = true;

        lockQuadrantRotation();

        if( movingPlayerIsNetworkOrAI ){
            lockBoardPieces();
        }
        else{
            unlockBoardPieces();
        }
    }

    Connections{
        onRotationLegallyClicked:{

            if( isSinglePlayerGame || isNetworkGame ){
                waitingOnNetworkOrAIMove = true;
            }

            playRotateAnimationOnQuadrant( index, direction );
            userMoveTimeout.startTimer();
        }

    }

    Connections{
        target: gameController
        onReadyForGuiMove:{


            var aiOrNetworkMove = gameController.getOpponentsTurn();

            console.log( "ready for gui move..." );

            if( waitingOnNetworkOrAIMove && !waitingForAISoWeCanExitGame  ){

                console.log("Network/AI move: " + aiOrNetworkMove);
                waitingForAnimationsToFinish = true;
                placeNetworkOrAIPiece( aiOrNetworkMove[0], aiOrNetworkMove[1] );
                waitingOnNetworkOrAIMove = false;
                if( parseInt(aiOrNetworkMove[2]) !== 111 ) //DONT_ROTATE_CODE
                {
                    //console.log("telling the timer rotation data" );
                    aiOrNetworkMoveTimeout.quadrantToRotate = aiOrNetworkMove[2];
                    aiOrNetworkMoveTimeout.rotationDirection = aiOrNetworkMove[3];
                    aiOrNetworkMoveTimeout.startTimer();
                }
            }
            else{
                console.log( "hmm... was not waiting on network or ai move..." );
            }

        }


        onReadyForVersusMove:{
            unlockBoardPieces();
        }

    }


    NetworkLobby{
        id:networkLobby
        anchors.centerIn: parent
    }

    GenericPopup{
        id: networkPlayerDisconnectedPopup
        message: "Connection lost."
        hideButton2: true
        anchors.centerIn: page
        z: 400
        button1Text: "Exit"

        QmlTimer{
            id: reconnectSuccessTimer
            duration: 1000
            onTriggered:{
                networkPlayerDisconnectedPopup.state = "INVISIBLE";
                networkPlayerDisconnectedPopup.message = "Connection lost.";
                networkPlayerDisconnectedPopup.enableButton1();
            }
        }

        Connections{
            target: page
            onOpponentDisconnected:{
                if( startMenu.state == "INVISIBLE" && networkLobby.state == "INVISIBLE" && isNetworkGame ){
                    networkPlayerDisconnectedPopup.state = "VISIBLE";
                    allGameScreenButtonsAreLocked = true;
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
            interval: 6000
            repeat: false
            running: true

            onTriggered:{
                escKeyQuit.focus = false;
                musicPlayer.togglePlayback();
                _SOUND_CHECK_FLAG = true;
                splash.visible = true;
                loadingScreen.visible = false;
                load()
                console.log("loaded");
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

    IntroScreen{
        id: introScreen
        anchors.centerIn: parent
    }

    ForkliftMenu{
        id:startMenu
        anchors.centerIn: parent
        z: 100
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
