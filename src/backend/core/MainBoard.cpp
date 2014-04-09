#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include <string>
#include <cassert>
#include "BoardLocation.h"
#include "GameData.h"
#include "Turn.h"
#include "BitBoard.h"
#include "MainBoard.h"

MainBoard::MainBoard(){
    reset();
}

MainBoard::MainBoard( const MainBoard& b){
    whiteBoard = b.whiteBoard;
    blackBoard = b.blackBoard;
    movingPlayersColor = b.movingPlayersColor;
}

MainBoard::MainBoard( const BitBoard& white, const BitBoard& black, PlayerColor mover ){
    whiteBoard = white;
    blackBoard = black;
    movingPlayersColor = mover;
}

const BitBoard& MainBoard::getBoardOfPlayer( PlayerColor player ) const {
    assert(player != PlayerColor::NONE);
    return (player == PlayerColor::BLACK? blackBoard : whiteBoard );
}

void MainBoard::setFirstMover( PlayerColor first ){
    movingPlayersColor = first;
}

PlayerColor MainBoard::turnColor() const{
    return movingPlayersColor;
}

void MainBoard::reset(){

    blackBoard.reset();
    whiteBoard.reset();
    movingPlayersColor = PlayerColor::WHITE;
}

PlayerColor MainBoard::pieceAt (BoardLocation bl) const {
    if (whiteBoard.hasPieceAt(bl.quadrantIndex, bl.pieceIndex))
        return PlayerColor::WHITE;
    else if (blackBoard.hasPieceAt(bl.quadrantIndex, bl.pieceIndex))
        return PlayerColor::BLACK;
    else
        return PlayerColor::NONE;
}

PlayerColor MainBoard::pieceAt ( short quadrantIndex, short pieceIndex ) const {
    if (whiteBoard.hasPieceAt(quadrantIndex, pieceIndex))
        return PlayerColor::WHITE;
    else if (blackBoard.hasPieceAt(quadrantIndex, pieceIndex))
        return PlayerColor::BLACK;
    else
        return PlayerColor::NONE;
}

bool MainBoard::holeIsEmpty( short quadrantIndex, short pieceIndex ) const {
    return pieceAt( quadrantIndex, pieceIndex ) == PlayerColor::NONE;
}

GameData MainBoard::checkWin() const {

    GameData result;

    bool whiteWon = whiteBoard.didWin();
    bool blackWon = blackBoard.didWin();

    //qDebug() << std::boolalpha << "whiteWon: " << whiteWon << "; blackWon: " << blackWon;

    //both won or board is full
    result.isDraw = ( blackWon && whiteWon ) || ((BoardInt)(blackBoard | whiteBoard) == FULL_BOARD);

   // qDebug() << "isDraw = " << result.isDraw;

    result.winner = NONE;

    if(!result.isDraw){
        if( whiteWon ){
            result.winner = WHITE;
        }
        else if( blackWon ){
            result.winner = BLACK;
        }
    }

    return result;
}

bool MainBoard::move( Turn t ){

    bool result = false;

    BitBoard& ref = (movingPlayersColor==BLACK? blackBoard : whiteBoard);
    BitBoard opponent = (movingPlayersColor==BLACK? whiteBoard : blackBoard);

    BitBoard copy = (movingPlayersColor==BLACK? blackBoard : whiteBoard);

    ref.placePiece(t.getHole().quadrantIndex, t.getHole().pieceIndex );

    bool moveIsValid = (copy != ref) && ((ref & opponent) == 0);

    assert( movingPlayersColor == t.getPieceColor() );

    if( moveIsValid ){
        movingPlayersColor = (t.getPieceColor() == PlayerColor::BLACK)? PlayerColor::WHITE : PlayerColor::BLACK;

        blackBoard.rotate(t.getQuadrantToRotate(), t.getRotationDirection() );
        whiteBoard.rotate(t.getQuadrantToRotate(), t.getRotationDirection() );

        //pieceCount++;
        result = true;
    }

    return result;

}

void MainBoard::print() const {
    qDebug() << '\n';

    for( int row = 0; row < 6; ++row ){
        auto blackStringRow = blackBoard.getPrintableRow(row);
        auto whiteStringRow = whiteBoard.getPrintableRow(row);

        QString combinedRow;

        for( int column = 0; column < 6; ++column ){
            if( blackStringRow[column] == '1' ){
                combinedRow += 'B';
            }
            else if( whiteStringRow[column] == '1' ){
                combinedRow += 'W';
            }
            else{
                combinedRow += '.';
            }
        }

        qDebug() << combinedRow;
    }
}

GameData MainBoard::checkEarlyWin( BoardLocation partialMove, PlayerColor color ) const {

    GameData result;
    result.isDraw = false;
    result.winner = PlayerColor::NONE;

    const BitBoard& ref = (movingPlayersColor==PlayerColor::BLACK? blackBoard : whiteBoard);
    BitBoard copy = (movingPlayersColor==PlayerColor::BLACK? blackBoard : whiteBoard);

    copy.placePiece(partialMove.quadrantIndex, partialMove.pieceIndex );

    bool moveIsValid = copy != ref;

    if(!(movingPlayersColor == color && moveIsValid)){
            qDebug() << "movingPlayersColor: " << color << " && " << "moveIsValid: " << moveIsValid;
            assert(false);
    }

    if( copy.didWin() ){
        qDebug() << "early win found";
        result.winner = movingPlayersColor;
    }

    return result;

}
