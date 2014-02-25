#ifndef RANDOMPLAYER_H
#define RANDOMPLAYER_H

#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include <string>
#include <cassert>
#include <time.h>
#include "player.h"

//Makes a random move
class RandomPlayer : public Player {
    public:
    Turn getMove(const Board& b) override{

        Turn myTurn;
        myTurn.setPieceColor( myColor );
        myTurn.setQuadrantToRotate(rand() % 4);
        myTurn.setRotationDirection( rand() % 2 == 0? Direction::LEFT : Direction::RIGHT );
        Board currentBoard;

        do{

            //need a fresh copy each time through
            currentBoard = b;

            BoardLocation hole;
            hole.quadrantIndex = rand() % 4;
            hole.pieceIndex = rand() % 9;
            myTurn.setHole(hole);

        }while( currentBoard.pieceAt(myTurn.getHole()) != PlayerColor::NONE );

        return myTurn;
    }

};

#endif
