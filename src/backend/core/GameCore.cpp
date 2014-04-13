#include "GameCore.h"
#include "MainBoard.h"

Board GameCore::copyCurrentBoard(){
    return currentBoard;
}

void GameCore::setMovingPlayerColor( PlayerColor mover ){
    currentBoard.setFirstMover( mover );
}

void GameCore::startNewGame() {

    //inform players that a new game is starting
    currentBoard.reset();

    gameData.winner = PlayerColor::NONE;
    gameData.isDraw = false;
}

void GameCore::registerTurnWithBoard( Turn playersMove ){

    if( playersMove.getQuadrantToRotate() == DONT_ROTATE_CODE ){
        gameData = currentBoard.checkEarlyWin( playersMove.getHole(), playersMove.getPieceColor() );

        //if a rotationless move comes here, it better be a winner
        if(gameData.winner == PlayerColor::NONE ){
           //assert(false);
        }
    }
    else{
        //set the move in motion, change the board
        if(!currentBoard.move(playersMove)){
           //assert(false);
        }

         gameData = currentBoard.checkWin();
    }

    gameData.lastMover = playersMove.getPieceColor();
}

bool GameCore::isGameOver() const{
    return gameData.winner != PlayerColor::NONE || gameData.isDraw;
}
