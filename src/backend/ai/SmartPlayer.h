#ifndef SMARTPLAYER_H
#define SMARTPLAYER_H

#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include <string>
#include <cassert>
#include <time.h>
#include <type_traits>

#include "Player.h"

#define MAX_PIECES_ON_BOARD 36
#define MAX_PIECES_ON_QUADRANT 9
#define NUMBER_OF_POSSIBLE_ROTATIONS 8
#define NUMBER_OF_QUADRANTS 4



class SmartPlayer : public Player {

    //GameCore* const gameCore;

    struct RotationConfig{
        Direction direction;
        short quadrantIndex;


        inline RotationConfig& operator++(){
            if( direction == Direction::LEFT ){
                direction = Direction::RIGHT;
            }
            else{
                direction = Direction::LEFT;
                if(quadrantIndex == 3){
                    quadrantIndex = 0;
                }
                else{
                    ++quadrantIndex;
                }
            }

            return *this;
        }

        inline void randomize(){
            direction = (Direction)(qrand()%2);
            quadrantIndex = qrand()%4;
        }
    };

    int moveCount;
    bool isFirstMove;
    Turn lastMove;

    /*static constexpr long double WIN_WEIGHT = 119769;
    static constexpr long double FOUR_WEIGHT = 19961.5;
    static constexpr long double THREE_WEIGHT = 486.866;
    static constexpr long double TWO_WEIGHT = 2.71992;
    static constexpr long double DEFAULT_WEIGHT = 1.35996;*/

    static constexpr long double WIN_WEIGHT = INT_MAX;
    static constexpr long double FOUR_WEIGHT = 2008595;
    static constexpr long double THREE_WEIGHT =3807.59;
    static constexpr long double TWO_WEIGHT = 5.07002;
    static constexpr long double DEFAULT_WEIGHT = 1;
    static constexpr int DEFENSE_FACTOR = 97;
    static_assert( THREE_WEIGHT != 0 && FOUR_WEIGHT != 0 && TWO_WEIGHT != 0 && WIN_WEIGHT * WIN_WEIGHT > 0, "dividing too small in AI code" );


public:

    SmartPlayer():moveCount(0),isFirstMove(true){



        std::cout << "WIN_WEIGHT: " << WIN_WEIGHT;
        std::cout << "\nFOUR_WEIGHT: " << FOUR_WEIGHT;
        std::cout << "\nTHREE_WEIGHT: " << THREE_WEIGHT;
        std::cout << "\nTWO_WEIGHT: " << TWO_WEIGHT;
        std::cout << "\nDEFAULT_WEIGHT: " << DEFAULT_WEIGHT << "\n";
    }

    void printWeights(){
        std::cout << "SmartPlayer won the tournament!\n";
    }

    static inline long double evaluateBitBoard( const BitBoard& boardToCheck, const BitBoard& opponentsBoard,  const BitBoard& myOriginalBoard ) {

        long double resultWeight = DEFAULT_WEIGHT;

        for(BitBoard winningBoard : WINS){
            if( boardToCheck.hasPattern(winningBoard) && !winningBoard.overlapsPattern( opponentsBoard ) ){

                resultWeight += WIN_WEIGHT;
            }
        }

        if( resultWeight > DEFAULT_WEIGHT )
            return resultWeight;

        for( unsigned char fourInARowIndex = 0; fourInARowIndex < NUMBER_OF_SIGNIFICANT_FOUR_IN_A_ROW_PATTERNS; ++fourInARowIndex ){

            BoardInt fourInARowBoard = FOUR_IN_A_ROW[fourInARowIndex];

            //if( boardToCheck has a four-in-a-row pattern we didn't already have
            if( !myOriginalBoard.hasPattern( fourInARowBoard ) && boardToCheck.hasPattern( fourInARowBoard ) ){

                assert(!opponentsBoard.overlapsPattern(fourInARowBoard));

                BoardInt futureWinPattern1 = FOUR_TO_FIVE_IN_A_ROW[fourInARowIndex][0];
                BoardInt futureWinPattern2 = FOUR_TO_FIVE_IN_A_ROW[fourInARowIndex][1];

                // make sure the four-in-a-row patterns aren't blocked on at least one end
                if( !opponentsBoard.overlapsPattern(futureWinPattern1) ){
                    resultWeight += FOUR_WEIGHT;
                }

                if( futureWinPattern2 != 0 && !opponentsBoard.overlapsPattern(futureWinPattern2) ){
                    resultWeight += FOUR_WEIGHT;
                }
            }
        }

        assert( resultWeight > 0 );

        if( resultWeight > DEFAULT_WEIGHT )
            return resultWeight;

        for( unsigned char threeInARowIndex = 0; threeInARowIndex < NUMBER_OF_SIGNIFICANT_THREE_IN_A_ROW_PATTERNS; ++threeInARowIndex ){
            BoardInt threeInARowBoard = THREE_IN_A_ROW[threeInARowIndex];

            if( boardToCheck.hasPattern( threeInARowBoard ) && !myOriginalBoard.hasPattern( threeInARowBoard )  ){

                if( opponentsBoard.overlapsPattern(threeInARowBoard) ){
                    assert( false );
                }

                BoardInt future4Pattern1 = THREE_TO_FOUR_IN_A_ROW[threeInARowIndex][0];
                BoardInt future4Pattern2 = THREE_TO_FOUR_IN_A_ROW[threeInARowIndex][1];
                int future4Pattern1Index = THREE_TO_FOUR_IN_A_ROW_INDEXES[threeInARowIndex][0];
                int future4Pattern2Index = THREE_TO_FOUR_IN_A_ROW_INDEXES[threeInARowIndex][1];

                if( !opponentsBoard.overlapsPattern(future4Pattern1) ){

                    BoardInt futureWinPattern1 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern1Index][0];
                    BoardInt futureWinPattern2 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern1Index][1];

                    if( !opponentsBoard.overlapsPattern(futureWinPattern1) ){
                        resultWeight += THREE_WEIGHT;
                    }
                    if( futureWinPattern2 != 0 && !opponentsBoard.overlapsPattern(futureWinPattern2) ){
                        resultWeight += THREE_WEIGHT;
                    }
                }

                if( future4Pattern2Index != -1 && !opponentsBoard.overlapsPattern(future4Pattern2) ){

                    BoardInt futureWinPattern1 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern2Index][0];
                    BoardInt futureWinPattern2 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern2Index][1];

                    if( !opponentsBoard.overlapsPattern(futureWinPattern1) ){
                        resultWeight += THREE_WEIGHT;
                    }
                    if( futureWinPattern2 != 0 && !opponentsBoard.overlapsPattern(futureWinPattern2) ){
                           resultWeight += THREE_WEIGHT;
                    }
                }
            }
        }

        if( resultWeight > DEFAULT_WEIGHT )
            return resultWeight;


        for( BitBoard twoInARowBoard : TWO_IN_A_ROW ){
            if( boardToCheck.hasPattern(twoInARowBoard) && !opponentsBoard.overlapsPattern(twoInARowBoard) ){
                resultWeight += TWO_WEIGHT;
            }
        }

        return resultWeight;
    }

    //obviously this wouldn't work right now -- the MainBoard would need to accept a
    //move as a BitBoard and & it with itself. The GuiGameController would also have to be
    //slightly changed.
    Turn getMove(const Board& mainBoard) override{

        //qDebug() << "calculating move with SmarterPlayer2, moveCount = " << moveCount;
        BitBoard myOriginalBoard = mainBoard.getBoardOfPlayer(myColor);

        long double bestMoveWeight = INT_MIN;
        Turn bestMove;

        //make every possible move for mover
        //make every possible piece placement

        for( int quadrantIndex =  qrand()% 4, quadrantCount = 0;  quadrantCount < NUMBER_OF_QUADRANTS;    quadrantIndex = ((quadrantIndex == 3)? 0 : quadrantIndex + 1), ++quadrantCount ){
            for( int pieceIndex = qrand()%9, pieceCount = 0;     pieceCount    < MAX_PIECES_ON_QUADRANT;   pieceIndex  = ((pieceIndex    == 8)? 0 : pieceIndex    + 1), ++pieceCount    ){

                if( mainBoard.holeIsEmpty( quadrantIndex, pieceIndex )){

                    if( bestMove.isEmpty() ){
                        bestMove = Turn( quadrantIndex, pieceIndex, 0, Direction::LEFT, myColor );
                    }

                    //place the piece
                    BitBoard tryPieceHere = myOriginalBoard;
                    tryPieceHere.placePiece(quadrantIndex, pieceIndex);

                    //loop through all 8 possible rotations
                    int rotationCount = 0;
                    RotationConfig rotationConfig;
                    for( rotationConfig.randomize(); rotationCount < NUMBER_OF_POSSIBLE_ROTATIONS; ++rotationCount, ++rotationConfig ){

                        BitBoard boardToRotate = tryPieceHere;
                        boardToRotate.rotate( rotationConfig.quadrantIndex, rotationConfig.direction );
                        BitBoard opponentsBoard = mainBoard.getBoardOfPlayer(opponentColor);
                        opponentsBoard.rotate( rotationConfig.quadrantIndex, rotationConfig.direction );

                        long double checkWeight = evaluateBitBoard( boardToRotate, opponentsBoard, myOriginalBoard );

                        Board test(boardToRotate,opponentsBoard, util.opposite(myColor) );

                        if( test.checkWin().winner == myColor && !test.checkWin().isDraw ){
                            return Turn(quadrantIndex, pieceIndex, rotationConfig.quadrantIndex, rotationConfig.direction, myColor);
                        }



                        if( checkWeight > bestMoveWeight && !test.checkWin().isDraw ){

                            long double opponentsBestMoveWeight = 0;
                            for( int quadrantIndexOpp = qrand() % 4, quadrantCountOpp = 0;  quadrantCountOpp < NUMBER_OF_QUADRANTS;    quadrantIndexOpp = ((quadrantIndexOpp == 3)? 0 : quadrantIndexOpp + 1), ++quadrantCountOpp ){
                                for( int pieceIndexOpp = qrand()%9, pieceCountOpp = 0;     pieceCountOpp    < MAX_PIECES_ON_QUADRANT;   pieceIndexOpp  = ((pieceIndexOpp    == 8)? 0 : pieceIndexOpp    + 1), ++pieceCountOpp    ){

                                    if( test.holeIsEmpty( quadrantIndexOpp, pieceIndexOpp )){

                                        //place the piece
                                        BitBoard tryPieceHereOpp = opponentsBoard;
                                        tryPieceHereOpp.placePiece(quadrantIndexOpp, pieceIndexOpp);


                                        //loop through all 8 possible rotations
                                        int rotationCountOpp = 0;
                                        RotationConfig rotationConfigOpp;
                                        for( rotationConfigOpp.randomize(); rotationCountOpp < NUMBER_OF_POSSIBLE_ROTATIONS; ++rotationCountOpp, ++rotationConfigOpp ){

                                            BitBoard boardToRotateOpp = tryPieceHereOpp;
                                            boardToRotateOpp.rotate( rotationConfigOpp.quadrantIndex, rotationConfigOpp.direction );
                                            BitBoard opponentsBoardOpp = boardToRotate;
                                            opponentsBoardOpp.rotate( rotationConfigOpp.quadrantIndex, rotationConfigOpp.direction );

                                            long double checkWeightOpp = evaluateBitBoard( boardToRotateOpp, opponentsBoardOpp, opponentsBoard );

                                            Board test(boardToRotateOpp,opponentsBoardOpp, myColor );

                                            assert( checkWeightOpp  > 0 );

                                            if( checkWeightOpp  > opponentsBestMoveWeight ){
                                               opponentsBestMoveWeight = checkWeightOpp;
                                            }
                                        }
                                    }
                                }
                            }


                           long double realCheckWeight = checkWeight - (opponentsBestMoveWeight * DEFENSE_FACTOR);

                           if( realCheckWeight > bestMoveWeight ){
                                bestMove = Turn(quadrantIndex, pieceIndex, rotationConfig.quadrantIndex, rotationConfig.direction, myColor);
                                bestMoveWeight = realCheckWeight;
                           }
                        }
                    }
                }
            }
        }

        return bestMove;

    }

};


#endif // SMARTPLAYER_H
