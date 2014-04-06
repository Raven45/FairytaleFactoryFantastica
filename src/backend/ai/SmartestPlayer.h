#ifndef CONCURRENTSMARTESTPLAYER_H
#define CONCURRENTSMARTESTPLAYER_H

#include <QtConcurrent>
#include <QFuture>

#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include <string>
#include <cassert>
#include <time.h>
#include <type_traits>
#include <utility>

#include "Player.h"

#define MAX_PIECES_ON_BOARD 36
#define MAX_PIECES_ON_QUADRANT 9
#define NUMBER_OF_POSSIBLE_ROTATIONS 8
#define NUMBER_OF_QUADRANTS 4



class ConcurrentSmartestPlayer : public Player {

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

    bool isFirstMove;
    Turn lastMove;
    double my_longest_time;

    /*static constexpr long double WIN_WEIGHT = 119769;
    static constexpr long double FOUR_WEIGHT = 19961.5;
    static constexpr long double THREE_WEIGHT = 300;
    static constexpr long double TWO_WEIGHT = 1.02;
    static constexpr long double DEFAULT_WEIGHT = 1;*/

    /*static constexpr long double WIN_WEIGHT = INT_MAX;
    static constexpr long double FOUR_WEIGHT = INT_MAX/288;
    static constexpr long double THREE_WEIGHT =FOUR_WEIGHT/288;
    static constexpr long double TWO_WEIGHT = THREE_WEIGHT/288;
    static constexpr long double DEFAULT_WEIGHT = 1;
    static constexpr int DEFENSE_FACTOR = 2;
    static constexpr int MAX_EXTRA_LEVELS = 1;*/

    /*static constexpr long double WIN_WEIGHT = INT_MAX/100;
    static constexpr long double FOUR_WEIGHT = 20595;
    static constexpr long double THREE_WEIGHT =37.59;
    static constexpr long double TWO_WEIGHT = 2.07002;
    static constexpr long double DEFAULT_WEIGHT = 1;*/

    static constexpr long double WIN_WEIGHT = 27721000;
    static constexpr long double FOUR_WEIGHT = 91253.4;
    static constexpr long double THREE_WEIGHT =300.393;
    static constexpr long double TWO_WEIGHT = 1.001;
    static constexpr long double DEFAULT_WEIGHT = 1;
    static constexpr long double PATTERN_WEIGHT1 = 10000;
    static constexpr long double PATTERN_WEIGHT2 = 20000;
    static constexpr long double PATTERN_WEIGHT3 = 30000;
    static constexpr long double PATTERN_WEIGHT4 = 40000;
    //2,2,1,2 = good
    //1.5,2,1,2 = better
    static constexpr long double DEFENSE_FACTOR = 1.1;
    static constexpr long double EVAL_DEFENSE_FACTOR = 1.9;
    static constexpr int MAX_EXTRA_LEVELS = 2;
    static constexpr long double OPPONENT_LEVEL_FACTOR = 2.37;

    static_assert( THREE_WEIGHT != 0 && FOUR_WEIGHT != 0 && TWO_WEIGHT != 0 && WIN_WEIGHT * WIN_WEIGHT > 0, "dividing too small in AI code" );



public:

    ConcurrentSmartestPlayer():isFirstMove(true){

        my_longest_time = 0;
        std::cout << "WIN_WEIGHT: " << WIN_WEIGHT;
        std::cout << "\nFOUR_WEIGHT: " << FOUR_WEIGHT;
        std::cout << "\nTHREE_WEIGHT: " << THREE_WEIGHT;
        std::cout << "\nTWO_WEIGHT: " << TWO_WEIGHT;
        std::cout << "\nDEFAULT_WEIGHT: " << DEFAULT_WEIGHT << "\n";
    }

    void printWeights() {
        std::cout << "SmartestPlayer won the tournament!\n";
    }

    static inline long double newEvaluateBitBoard( const BitBoard& boardToCheck, const BitBoard& opponentsBoard,  const BitBoard& myOriginalBoard ) {

        long double resultWeight = DEFAULT_WEIGHT;



        for(unsigned int winIndex = 32; winIndex--;){
            const BitBoard winningBoard = WINS[winIndex];
            if( boardToCheck.hasPattern(winningBoard) && !winningBoard.overlapsPattern( opponentsBoard ) ){

                resultWeight += WIN_WEIGHT;
            }
            //account for opponents board! Important new feature!!
            else if( opponentsBoard.hasPattern(winningBoard) && !winningBoard.overlapsPattern( boardToCheck ) ){
                resultWeight -= WIN_WEIGHT * EVAL_DEFENSE_FACTOR;
            }
        }

        if( resultWeight != DEFAULT_WEIGHT ){


            return resultWeight;

        }

        for( BoardInt pattern : START_PATTERNS1 ){
            if( boardToCheck == pattern ){
                resultWeight += PATTERN_WEIGHT1;
            }
        }

        for( BoardInt pattern : START_PATTERNS2 ){
            if( boardToCheck == pattern ){
                resultWeight += PATTERN_WEIGHT2;
            }
            else if( opponentsBoard == pattern ){
                resultWeight -= PATTERN_WEIGHT2*EVAL_DEFENSE_FACTOR;
            }
        }

        if( resultWeight != DEFAULT_WEIGHT ){
            return resultWeight;
        }

        for( BoardInt pattern : START_PATTERNS3 ){
            if( boardToCheck == pattern ){
                resultWeight += PATTERN_WEIGHT3;
            }
            else if( opponentsBoard == pattern ){
                resultWeight -= PATTERN_WEIGHT3*EVAL_DEFENSE_FACTOR;
            }
        }

        if( resultWeight != DEFAULT_WEIGHT ){
            return resultWeight;
        }

        for( BoardInt pattern : START_PATTERNS4 ){
            if( boardToCheck == pattern ){
                resultWeight += PATTERN_WEIGHT4;
            }
            else if( opponentsBoard == pattern ){
                resultWeight -= PATTERN_WEIGHT4*EVAL_DEFENSE_FACTOR;
            }
        }


        //optimize
        for( unsigned char fourInARowIndex = NUMBER_OF_SIGNIFICANT_FOUR_IN_A_ROW_PATTERNS; fourInARowIndex--; ){

            BoardInt fourInARowBoard = FOUR_IN_A_ROW[fourInARowIndex];

            //if( boardToCheck has a four-in-a-row pattern we didn't already have
            if( !myOriginalBoard.hasPattern( fourInARowBoard ) && boardToCheck.hasPattern( fourInARowBoard ) ){

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

            else if( opponentsBoard.hasPattern( fourInARowBoard )  ){

                BoardInt futureWinPattern1 = FOUR_TO_FIVE_IN_A_ROW[fourInARowIndex][0];
                BoardInt futureWinPattern2 = FOUR_TO_FIVE_IN_A_ROW[fourInARowIndex][1];

                // make sure the four-in-a-row patterns aren't blocked on at least one end
                if( !boardToCheck.overlapsPattern(futureWinPattern1) ){
                    resultWeight -= FOUR_WEIGHT*EVAL_DEFENSE_FACTOR;
                }

                if( futureWinPattern2 != 0 && !boardToCheck.overlapsPattern(futureWinPattern2) ){
                    resultWeight -= FOUR_WEIGHT*EVAL_DEFENSE_FACTOR;
                }
            }
        }

        //TODO: test to see whether removing this early return is helpful
        if( resultWeight != DEFAULT_WEIGHT ){


            return resultWeight;

        }

        for( unsigned char threeInARowIndex = NUMBER_OF_SIGNIFICANT_THREE_IN_A_ROW_PATTERNS; threeInARowIndex--; ){
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

            else if(  opponentsBoard.hasPattern( threeInARowBoard ) ){

                BoardInt future4Pattern1 = THREE_TO_FOUR_IN_A_ROW[threeInARowIndex][0];
                BoardInt future4Pattern2 = THREE_TO_FOUR_IN_A_ROW[threeInARowIndex][1];
                int future4Pattern1Index = THREE_TO_FOUR_IN_A_ROW_INDEXES[threeInARowIndex][0];
                int future4Pattern2Index = THREE_TO_FOUR_IN_A_ROW_INDEXES[threeInARowIndex][1];

                if( !boardToCheck.overlapsPattern(future4Pattern1) ){

                    BoardInt futureWinPattern1 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern1Index][0];
                    BoardInt futureWinPattern2 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern1Index][1];

                    if( !boardToCheck.overlapsPattern(futureWinPattern1) ){
                        resultWeight -= THREE_WEIGHT*EVAL_DEFENSE_FACTOR;
                    }
                    if( futureWinPattern2 != 0 && !boardToCheck.overlapsPattern(futureWinPattern2) ){
                        resultWeight -= THREE_WEIGHT*EVAL_DEFENSE_FACTOR;
                    }
                }

                if( future4Pattern2Index != -1 && !boardToCheck.overlapsPattern(future4Pattern2) ){

                    BoardInt futureWinPattern1 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern2Index][0];
                    BoardInt futureWinPattern2 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern2Index][1];

                    if( !boardToCheck.overlapsPattern(futureWinPattern1) ){
                        resultWeight -= THREE_WEIGHT*EVAL_DEFENSE_FACTOR;
                    }
                    if( futureWinPattern2 != 0 && !boardToCheck.overlapsPattern(futureWinPattern2) ){
                           resultWeight -= THREE_WEIGHT*EVAL_DEFENSE_FACTOR;
                    }
                }
            }
        }

        if( resultWeight != DEFAULT_WEIGHT ){
            return resultWeight;
        }

        for( unsigned char twoIndex = countof(TWO_IN_A_ROW); twoIndex--;){
            const BitBoard twoInARowBoard = TWO_IN_A_ROW[twoIndex];

            if( boardToCheck.hasPattern(twoInARowBoard) && !opponentsBoard.overlapsPattern(twoInARowBoard) ){
                resultWeight += TWO_WEIGHT;
            }

            else if( opponentsBoard.hasPattern(twoInARowBoard) && !boardToCheck.overlapsPattern(twoInARowBoard) ){
                resultWeight -= TWO_WEIGHT*EVAL_DEFENSE_FACTOR;
            }
        }


        return resultWeight;

    }


    template<typename T, size_t N>
    static constexpr size_t countof(T (&)[N]) { return N; }

    static inline long double getRecursiveWeight( const Board b, const PlayerColor movingPlayersColor, const PlayerColor opponentsColor, const unsigned char level = 1 ){

        BitBoard movingPlayersBoardBeforeTurn = b.getBoardOfPlayer(movingPlayersColor);
        BitBoard opponentsBoardBeforeTurn = b.getBoardOfPlayer( opponentsColor );

        long double bestMoveWeight = INT_MIN;
        bool beenThroughOnce = false;
        for( int quadrantIndex =  4; quadrantIndex--;){
            for( int pieceIndex = 9; pieceIndex--;){

                if( b.holeIsEmpty( quadrantIndex, pieceIndex )){

                    //place the piece
                    BitBoard movingPlayersNewBoard = movingPlayersBoardBeforeTurn;
                    movingPlayersNewBoard.placePiece(quadrantIndex, pieceIndex);

                    for( unsigned char rotationIndex = 4; rotationIndex--;){

                        BitBoard newBoardCopy = movingPlayersNewBoard;
                        newBoardCopy.rotate( rotationIndex, LEFT );
                        BitBoard opponentsBoard = opponentsBoardBeforeTurn;
                        opponentsBoard.rotate( rotationIndex, LEFT );

                        long double newMoveWeight = newEvaluateBitBoard(newBoardCopy, opponentsBoard, movingPlayersBoardBeforeTurn /*, opponentsBoardBeforeTurn */ );

                        if( level == 1 ){
                            newMoveWeight *= OPPONENT_LEVEL_FACTOR;
                        }



                        Board testBoard;// (movingPlayersColor == PlayerColor::WHITE? newBoardCopy:opponentsBoard, movingPlayersColor == PlayerColor::WHITE? opponentsBoard:newBoardCopy, opponentsColor );



                        if( movingPlayersColor == PlayerColor::WHITE ){
                            testBoard = Board(newBoardCopy,opponentsBoard, opponentsColor );
                        }
                        else{
                             testBoard = Board(opponentsBoard,newBoardCopy, opponentsColor );
                        }

                        if( testBoard.checkWin().winner == movingPlayersColor  ){
                            return WIN_WEIGHT;
                        }

                        if( level < MAX_EXTRA_LEVELS ){
                            newMoveWeight -= (getRecursiveWeight( testBoard, opponentsColor, movingPlayersColor, level + 1 )  * DEFENSE_FACTOR);
                        }

                        if(!beenThroughOnce){
                            bestMoveWeight = newMoveWeight;
                            beenThroughOnce = true;
                        }

                        else if( newMoveWeight > bestMoveWeight ){
                            bestMoveWeight = newMoveWeight ;
                        }

                        newBoardCopy = movingPlayersNewBoard;
                        newBoardCopy.rotate( rotationIndex, RIGHT );
                        opponentsBoard = opponentsBoardBeforeTurn;
                        opponentsBoard.rotate( rotationIndex, RIGHT );

                        newMoveWeight = newEvaluateBitBoard(newBoardCopy, opponentsBoard, movingPlayersBoardBeforeTurn /*, opponentsBoardBeforeTurn */ );

                        if( level == 1 ){
                            newMoveWeight *= OPPONENT_LEVEL_FACTOR;
                        }

                        Board testBoard2;

                        if( movingPlayersColor == PlayerColor::WHITE ){
                            testBoard2 = Board(newBoardCopy,opponentsBoard, opponentsColor );
                        }
                        else{
                             testBoard2 = Board(opponentsBoard,newBoardCopy, opponentsColor );
                        }


                        if( testBoard2.checkWin().winner == movingPlayersColor  ){
                            return WIN_WEIGHT;
                        }

                        if( level < MAX_EXTRA_LEVELS ){
                            newMoveWeight -= (getRecursiveWeight( testBoard2, opponentsColor, movingPlayersColor, level + 1 )  * DEFENSE_FACTOR);
                        }

                        else if( newMoveWeight > bestMoveWeight ){
                            bestMoveWeight = newMoveWeight ;
                        }


                    }
                }
            }
        }



        return bestMoveWeight;


    }


    static inline std::pair<Turn, long double> getMoveParallel (const Board& mainBoard, const PlayerColor myColor, const PlayerColor opponentColor, Direction direction, unsigned int seedRand ){
         //qDebug() << "calculating move with SmarterPlayer2, moveCount = " << moveCount;
         BitBoard myOriginalBoard = mainBoard.getBoardOfPlayer(myColor);

         long double bestMoveWeight = INT_MIN;
         bool beenThroughOnce = false;
         Turn bestMove;

         //make every possible move for mover
         //make every possible piece placement

         for( int quadrantIndex =  seedRand % 4, quadrantCount = 0;  quadrantCount < NUMBER_OF_QUADRANTS;    quadrantIndex = ((quadrantIndex == 3)? 0 : quadrantIndex + 1), ++quadrantCount ){
             for( int pieceIndex = seedRand %9, pieceCount = 0;     pieceCount    < MAX_PIECES_ON_QUADRANT;   pieceIndex  = ((pieceIndex    == 8)? 0 : pieceIndex    + 1), ++pieceCount    ){

                 if( mainBoard.holeIsEmpty( quadrantIndex, pieceIndex )){



                     //place the piece
                     BitBoard myNewBoard = myOriginalBoard;
                     myNewBoard.placePiece(quadrantIndex, pieceIndex);

                     for( unsigned char rotationIndex = 4; rotationIndex--;){

                         BitBoard boardToRotate = myNewBoard;
                         boardToRotate.rotate( rotationIndex, direction );
                         BitBoard opponentsBoard = mainBoard.getBoardOfPlayer(opponentColor);
                         opponentsBoard.rotate( rotationIndex, direction);

                         long double newMoveWeight = newEvaluateBitBoard( boardToRotate, opponentsBoard, myOriginalBoard /*, opponentsBoardBeforeTurn */ );


                         Board testBoard (myColor == BLACK? opponentsBoard:boardToRotate,myColor == BLACK? boardToRotate:opponentsBoard, util.opposite(myColor) );


                         newMoveWeight -= (getRecursiveWeight( testBoard, opponentColor, myColor ) * DEFENSE_FACTOR);


                         //pick first valid move by default
                         if( !beenThroughOnce ){
                             bestMove = Turn(quadrantIndex, pieceIndex, rotationIndex, direction, myColor);
                             bestMoveWeight = newMoveWeight;
                             beenThroughOnce = true;
                         }

                         else if( newMoveWeight > bestMoveWeight ){
                             bestMove = Turn(quadrantIndex, pieceIndex, rotationIndex, direction, myColor);
                             bestMoveWeight = newMoveWeight;
                         }
                     }
                 }
             }
         }




         return std::make_pair(bestMove,bestMoveWeight);

     }


    Turn getMove(const Board& mainBoard) override{
        clock_t begin = clock();

        Turn bestMove;

        QFuture< std::pair<Turn, long double> > futureLeft = QtConcurrent::run(getMoveParallel, mainBoard, myColor, opponentColor, LEFT, qrand() );
        QFuture< std::pair<Turn, long double> > futureRight = QtConcurrent::run(getMoveParallel, mainBoard, myColor, opponentColor, RIGHT, qrand() );

        std::pair<Turn, long double> resultLeft = futureLeft.result();
        std::pair<Turn, long double> resultRight = futureRight.result();

        if( resultRight.second > resultLeft.second ){
            bestMove = resultRight.first;
        }
        else{
            bestMove = resultLeft.first;
        }

        clock_t end = clock();
        double elapsed_secs = double(end - begin) / CLOCKS_PER_SEC;

        if( elapsed_secs > my_longest_time ){
            std::cout << "\nnew longest time: " << elapsed_secs << " seconds\n";
            my_longest_time = elapsed_secs;

        }

        return bestMove;

    }

};


#endif // CONCURRENTSMARTESTPLAYER_H
