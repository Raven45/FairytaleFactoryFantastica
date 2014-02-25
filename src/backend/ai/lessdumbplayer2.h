#ifndef LESSDUMBPLAYER2_H
#define LESSDUMBPLAYER2_H

#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include <string>
#include <cassert>
#include <time.h>

#include "Player.h"
#include "GameCore.h"

//plays randomly except
//1. places piece to win if possible
//2. rotates to win if possible
//3. will not rotate to lose if possible (but could rotate to draw)

class LessDumbPlayer2 : public Player {

    //GameCore* const gameCore;

    bool isFirstMove;
    Turn lastMove;

public:
    //LessDumbPlayer2( GameCore* gc ): gameCore(gc){
    //    isFirstMove = true;
    //}

public slots:
    Turn getMove(const Board& b) override{

        Turn myTurn;
        myTurn.setPieceColor( myColor );
        Board currentBoard;


        bool fiveInARowFound = false;




        //special case for first move
        if( isFirstMove ){
            isFirstMove = false;

            BoardLocation hole;
            hole.pieceIndex = 4;

            do{
                hole.quadrantIndex = rand() % 4;
                myTurn.setHole(hole);
            }while( currentBoard.pieceAt(myTurn.getHole()) != PlayerColor::NONE );
        }

        else{

            //see if any move (without rotation) results in a win.

            BoardLocation hole;
            hole.quadrantIndex = -1;
            myTurn.setQuadrantToRotate( 0 );
            myTurn.setRotationDirection( Direction::RIGHT );
            do{
                hole.quadrantIndex++;
                hole.pieceIndex = -1;

                do{

                    hole.pieceIndex++;

                    //need a fresh copy each time through
                    currentBoard = b;
                    myTurn.setHole(hole);
                    currentBoard.move(myTurn);

                    if(currentBoard.checkWin().winner == myColor){
                        fiveInARowFound = true;
                    }

                } while( myTurn.getHole().pieceIndex < 8 && !fiveInARowFound );
            }while ( myTurn.getHole().quadrantIndex < 3 && !fiveInARowFound );
        }

        //if five in a row isn't possible, then make a random move
        if( !fiveInARowFound ){

            do{

                currentBoard = b;
                BoardLocation bl;
                bl.quadrantIndex = rand() % 4;
                bl.pieceIndex = rand() % 9;
                myTurn.setHole(bl);
            //this while loop ensures we don't submit an illegal move (on top of a piece already played)
            }while( currentBoard.pieceAt(myTurn.getHole()) != PlayerColor::NONE );

        }


        /***
        now that the.getHole() to place the piece in has been determined,
        we need to determine the rotation phase of the move
        ***/

        bool winNotFound = true;

        //this loop looks for a rotation that wins
        //	note: if five in a row has already been found,
        //	this will move a
        for( short i = 0; i < 4 && winNotFound; ++i){

            myTurn.setQuadrantToRotate( i );
            myTurn.setRotationDirection( Direction::RIGHT );
            currentBoard = b;
            currentBoard.move(myTurn);

            GameData result = currentBoard.checkWin();

            if( result.winner == myColor ){

                winNotFound = false;

            }

            else{

                currentBoard = b;
                myTurn.setRotationDirection( Direction::LEFT );
                currentBoard.move(myTurn);
                result = currentBoard.checkWin();

                if(result.winner == myColor){

                    winNotFound = false;

                }
            }

        }

        //if we can't win with a rotation, pick a rotation that doesn't cause the opponent to win
        //NOTE: this can would still do a rotation to cause a draw
        if( winNotFound ){
            bool moveNotFound = true;
            for(short i = 0; i < 4 && moveNotFound; ++i ){
                myTurn.setQuadrantToRotate( i );
                myTurn.setRotationDirection( Direction::LEFT );

                currentBoard = b;
                currentBoard.move(myTurn);

                if( !(currentBoard.checkWin().winner == opponentColor)){
                    moveNotFound = false;
                }
                else{

                    //reset the board and try the other direction
                    currentBoard = b;
                    currentBoard.move(myTurn);

                    myTurn.setRotationDirection( Direction::RIGHT );

                    if( !(currentBoard.checkWin().winner == opponentColor)){
                        moveNotFound = false;
                    }
                }
            }
        }

        lastMove = myTurn;

        return myTurn;
        //gameCore -> registerTurnWithBoard(myTurn);
    }
};

#endif

