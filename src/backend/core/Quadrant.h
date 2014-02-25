#ifndef QUADRANT_H
#define QUADRANT_H

#include <string>
#include <QObject>

#include "Direction.h"
#include "PlayerColor.h"

class Quadrant {


    int moveCount;
    PlayerColor moves[9];

public:

    int numberOfPiecesInQuadrant() const {
        return moveCount;
    }

    bool isFull() const {
        return moveCount == 9;
    }

    PlayerColor pieceAt(int i) const {
        return moves[i];
    }

    bool placePiece(int location, PlayerColor currentTurn){

        bool isValid = true;

        if( isFull() || moves[location] != PlayerColor::NONE ){
            isValid = false;
        }

        else{
            moves[location] = currentTurn;
            moveCount++;
        }

        return isValid;
    }

    std::string getRow( int rowIndex ) const {
        assert( rowIndex < 3 && rowIndex >= 0 );
        std::string result = "";

        for( int i = 0; i < 3 ; ++i ){

            switch(moves[rowIndex * 3 + i]){
                case PlayerColor::NONE: result += '.';break;
                case PlayerColor::BLACK: result += 'B';break;
                case PlayerColor::WHITE: result += 'W';break;
            }

        }

        return result;
    }

    Quadrant(){
        reset();
    }

    Quadrant( const Quadrant& q ){
        moveCount = q.moveCount;
        memcpy( moves, q.moves, sizeof(PlayerColor)*9 );
    }

    void reset(){
        moveCount = 0;
        for(PlayerColor& m : moves){
            m = PlayerColor::NONE;
        }
    }

    void rotate( Direction d ){

        PlayerColor tempMoves[9];
        memcpy( tempMoves, moves, sizeof(PlayerColor)*9 );

        if( d == Direction::RIGHT ){
            moves[0] = tempMoves[6]; // 0 1 2 3 4 5 6 7 8
            moves[1] = tempMoves[3]; // 6 3 0 7 4 1 8 5 2
            moves[2] = tempMoves[0];
            moves[3] = tempMoves[7];
            moves[5] = tempMoves[1];
            moves[6] = tempMoves[8];
            moves[7] = tempMoves[5];
            moves[8] = tempMoves[2];
        }

        else if( d == Direction::LEFT ){
            moves[0] = tempMoves[2];
            moves[1] = tempMoves[5];
            moves[2] = tempMoves[8];
            moves[3] = tempMoves[1];
            moves[5] = tempMoves[7];
            moves[6] = tempMoves[0];
            moves[7] = tempMoves[3];
            moves[8] = tempMoves[6];
        }

    }

};

#endif // QUADRANT_H
