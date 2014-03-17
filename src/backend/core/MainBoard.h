#ifndef MAINBOARD_H
#define MAINBOARD_H

#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include <string>
#include <cassert>

#include "quadrant.h"
#include "BoardLocation.h"
#include "GameData.h"
#include "Turn.h"
#include "BitBoard.h"

#if PENTAGO_RELEASE == false
#include <QDebug>
#endif

class MainBoard {

    //friend class Player;

    BitBoard whiteBoard;
    BitBoard blackBoard;

    PlayerColor movingPlayersColor;
    //int pieceCount;
    public:

    const BitBoard& getBoardOfPlayer( PlayerColor player ) const {
        assert(player != PlayerColor::NONE);

        return (player == PlayerColor::BLACK? blackBoard : whiteBoard );
    }

    inline void setFirstMover( PlayerColor first ){
        movingPlayersColor = first;
    }

    PlayerColor turnColor() const{
        return movingPlayersColor;
    }

    MainBoard(){
        reset();
    }
    MainBoard( const MainBoard& b){
        whiteBoard = b.whiteBoard;
        blackBoard = b.blackBoard;
        movingPlayersColor = b.movingPlayersColor;
    }

    MainBoard( const BitBoard& w, const BitBoard& b, PlayerColor mover ){
        whiteBoard = w;
        blackBoard = b;
        movingPlayersColor = mover;
    }

    void reset(){

        blackBoard.reset();
        whiteBoard.reset();
        //pieceCount = 0;
        //white moves first
        movingPlayersColor = PlayerColor::WHITE;
    }

    /*inline int getPieceCount() const {
        return pieceCount;
    }*/

    PlayerColor pieceAt (BoardLocation bl){
        if (whiteBoard.hasPieceAt(bl.quadrantIndex, bl.pieceIndex))
            return PlayerColor::WHITE;
        else if (blackBoard.hasPieceAt(bl.quadrantIndex, bl.pieceIndex))
            return PlayerColor::BLACK;
        else
            return PlayerColor::NONE;
    }

    PlayerColor pieceAt ( short quadrantIndex, short pieceIndex ) const {
        if (whiteBoard.hasPieceAt(quadrantIndex, pieceIndex))
            return PlayerColor::WHITE;
        else if (blackBoard.hasPieceAt(quadrantIndex, pieceIndex))
            return PlayerColor::BLACK;
        else
            return PlayerColor::NONE;
    }

    bool holeIsEmpty( short quadrantIndex, short pieceIndex ) const {
        return pieceAt( quadrantIndex, pieceIndex ) == PlayerColor::NONE;
    }



    GameData checkWin() const {

        GameData result;

        bool whiteWon = whiteBoard.didWin();
        bool blackWon = blackBoard.didWin();

        //both won or board is full
        result.isDraw = ( blackWon && whiteWon ) || (blackBoard & whiteBoard) == FULL_BOARD;

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

    bool move( Turn t ){

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

    void print() {
        #if PENTAGO_RELEASE == false
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
        #endif
    }

    //this function checks to see if a move wins before a rotation happens, for gui
    GameData checkEarlyWin( BoardLocation partialMove, PlayerColor color ){

        GameData result;
        result.isDraw = false;
        result.winner = PlayerColor::NONE;

        BitBoard& ref = (movingPlayersColor==PlayerColor::BLACK? blackBoard : whiteBoard);
        BitBoard copy = (movingPlayersColor==PlayerColor::BLACK? blackBoard : whiteBoard);

        copy.placePiece(partialMove.quadrantIndex, partialMove.pieceIndex );

        bool moveIsValid = copy != ref;

        if(!(movingPlayersColor == color && moveIsValid)){
                assert(false);
        }

        if( copy.didWin() ){
            qDebug() << "early win found";
            result.winner = movingPlayersColor;
        }

        return result;

    }

};

typedef MainBoard Board;

#endif // MAINBOARD_H
