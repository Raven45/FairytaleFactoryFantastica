#ifndef LESSDUMBPLAYER3_H
#define LESSDUMBPLAYER3_H

#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include <string>
#include <cassert>
#include <time.h>
#include "player.h"

//plays randomly except
//1. places piece to win if possible
//2. rotates to win if possible
//3. will not rotate to lose if possible (but could rotate to draw)
//4. will give preference to placing tokens next to eachother

class LessDumbPlayer3 : public Player {

public:
    Turn getMove(const Board& b) override{

        Turn myTurn;
        myTurn.setPieceColor( myColor );
        Board currentBoard;


        bool fiveInARowFound = false;




        //special case for first move
        if( isFirstMove ){
            isFirstMove = false;

            myTurn.getHole().pieceIndex = 4;

            do{
                myTurn.getHole().quadrantIndex = rand() % 4;
            }while( currentBoard.pieceAt(myTurn.getHole()) != PlayerColor::NONE );
        }

        else{

            //see if any move (without rotation) results in a win.

            myTurn.getHole().quadrantIndex = -1;

            do{
                myTurn.getHole().quadrantIndex++;
                myTurn.getHole().pieceIndex = -1;

                do{

                    myTurn.getHole().pieceIndex++;

                    //need a fresh copy each time through
                    currentBoard = b;
                    currentBoard.move(myTurn);

                    if(currentBoard.checkWin().winner == myColor){
                        fiveInARowFound = true;
                    }

                } while( myTurn.getHole().pieceIndex < 8 && !fiveInARowFound );
            }while ( myTurn.getHole().quadrantIndex < 3 && !fiveInARowFound );
        }

        //if five in a row isn't possible, then search for a move that gives the most tokens in a row
        if( !fiveInARowFound && myTurn.getHole().pieceIndex != 4){
            Turn candidateMove;
            int bestMoveConsecutiveTokens = 0;
            for (int i = 0; i < 4; i++)
            {
                for (int j = 0; j < 9; j++){
                    currentBoard = b;
                    candidateMove.getHole().quadrantIndex = i;
                    candidateMove.getHole().pieceIndex = j;


                    if (currentBoard.pieceAt(candidateMove.getHole()) == PlayerColor::NONE){
                        //logic for checking the number of tokens in a row for this board
                        int consecutiveTokens = 0;

                        //check up
                        for (int checkUp = 0; checkUp < 4; checkUp++){

                            Turn tempHole;
                            //if within board bounds make a tempHole to check for myColor
                            if (candidateMove.getHole().pieceIndex - (3*checkUp+1) >= 0 || candidateMove.getHole().quadrantIndex > 1){
                                if (candidateMove.getHole().pieceIndex - (3*checkUp+1) < 0){
                                    tempHole.getHole().quadrantIndex = candidateMove.getHole().quadrantIndex - 2;
                                    tempHole.getHole().pieceIndex = 9 + candidateMove.getHole().pieceIndex - (3*checkUp+1);
                                }
                                else{
                                    tempHole.getHole().pieceIndex = candidateMove.getHole().pieceIndex - (3*checkUp+1);
                                    tempHole.getHole().quadrantIndex = candidateMove.getHole().quadrantIndex;
                                }
                            }
                            else{
                                checkUp = 5;
                            }

                            if (checkUp != 5 && currentBoard.pieceAt(tempHole.getHole()) == myColor){
                                consecutiveTokens++;
                                if (consecutiveTokens > bestMoveConsecutiveTokens){
                                    myTurn.getHole().quadrantIndex = candidateMove.getHole().quadrantIndex;
                                    myTurn.getHole().pieceIndex = candidateMove.getHole().pieceIndex - (3*checkUp+1);
                                }
                            }
                            else {
                                checkUp = 5;
                            }
                        }


                        consecutiveTokens = 0;
                        //check down
                        for (int checkDown = 0; checkDown < 4; checkDown++){

                            Turn tempHole;
                            //if within board bounds make a tempHole to check for myColor
                            if (candidateMove.getHole().pieceIndex + (3*checkDown+1) < 9  || candidateMove.getHole().quadrantIndex < 2){
                                if (candidateMove.getHole().pieceIndex + (3*checkDown+1) > 8){
                                    tempHole.getHole().quadrantIndex = candidateMove.getHole().quadrantIndex + 2;
                                    tempHole.getHole().pieceIndex = candidateMove.getHole().pieceIndex + (3*checkDown+1) - 9;
                                }
                                else{
                                    tempHole.getHole().pieceIndex = candidateMove.getHole().pieceIndex + (3*checkDown+1);
                                    tempHole.getHole().quadrantIndex = candidateMove.getHole().quadrantIndex;
                                }
                            }
                            else{
                                checkDown = 5;
                            }

                            if (checkDown != 5 && currentBoard.pieceAt(tempHole.getHole()) == myColor){
                                  consecutiveTokens++;
                                  if (consecutiveTokens > bestMoveConsecutiveTokens){
                                      myTurn.getHole().quadrantIndex = candidateMove.getHole().quadrantIndex;
                                      myTurn.getHole().pieceIndex = candidateMove.getHole().pieceIndex - (3*checkDown+1);
                                  }
                            }
                            else {
                                checkDown = 5;
                            }
                        }
                    }
                }
            }
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

            myTurn.quadrantToRotate = i;
            myTurn.rotationDirection = Direction::RIGHT;
            currentBoard = b;
            currentBoard.move(myTurn);

            GameData result = currentBoard.checkWin();

            if( result.winner == myColor ){

                winNotFound = false;

            }

            else{

                currentBoard = b;
                myTurn.rotationDirection = Direction::LEFT;
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
                myTurn.quadrantToRotate = i;
                myTurn.rotationDirection = Direction::LEFT;

                currentBoard = b;
                currentBoard.move(myTurn);

                if( !(currentBoard.checkWin().winner == opponentColor)){
                    moveNotFound = false;
                }
                else{

                    //reset the board and try the other direction
                    currentBoard = b;
                    currentBoard.move(myTurn);

                    myTurn.rotationDirection = Direction::RIGHT;

                    if( !(currentBoard.checkWin().winner == opponentColor)){
                        moveNotFound = false;
                    }
                }
            }
        }

        lastMove = myTurn;
        qDebug() << "\n" << myTurn.getHole().pieceIndex << " " << myTurn.getHole().quadrantIndex << "\n";
        return myTurn;
    }
};

#endif

