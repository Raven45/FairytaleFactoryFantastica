#include "GameCore.h"
#include "PentagoExceptions.h"

Board GameCore::copyCurrentBoard(){
    return currentBoard;
}

void GameCore::setMovingPlayerColor( PlayerColor mover ){
    currentBoard.setFirstMover( mover );
}

void GameCore::startNewGame(){

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
           throw InvalidMoveException(playersMove);
        }
    }
    else{
        //set the move in motion, change the board
        if(!currentBoard.move(playersMove)){
           throw InvalidMoveException(playersMove);
        }

         gameData = currentBoard.checkWin();
    }
}

bool GameCore::isGameOver() const{
    return gameData.winner != PlayerColor::NONE || gameData.isDraw;
}
