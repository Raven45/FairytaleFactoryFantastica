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

    unsigned char moveCount;
    double my_longest_time;

    static constexpr long double WIN_WEIGHT = 27721000;
    static constexpr long double FOUR_WEIGHT = 91253.4;
    static constexpr long double THREE_WEIGHT =300.393;
    static constexpr long double TWO_WEIGHT = 1.001;
    static constexpr long double DEFAULT_WEIGHT = 1;
    static constexpr long double PATTERN_WEIGHT1 = THREE_WEIGHT*THREE_WEIGHT;
    static constexpr long double PATTERN_WEIGHT2 = THREE_WEIGHT*THREE_WEIGHT;
    static constexpr long double PATTERN_WEIGHT3 = THREE_WEIGHT/2;
    static constexpr long double PATTERN_WEIGHT4 = THREE_WEIGHT/2;
    //2,2,1,2 = good
    //1.5,2,1,2 = better
    static constexpr long double DEFENSE_FACTOR = 1.1;
    static constexpr long double EVAL_DEFENSE_FACTOR = 1.9;
    static constexpr int MAX_EXTRA_LEVELS = 2;
    static constexpr long double OPPONENT_LEVEL_FACTOR = 5;

    static_assert( THREE_WEIGHT != 0 && FOUR_WEIGHT != 0 && TWO_WEIGHT != 0 && WIN_WEIGHT * WIN_WEIGHT > 0, "dividing too small in AI code" );



public:

    ConcurrentSmartestPlayer():moveCount(0),my_longest_time(0){
        std::cout << "WIN_WEIGHT: " << WIN_WEIGHT;
        std::cout << "\nFOUR_WEIGHT: " << FOUR_WEIGHT;
        std::cout << "\nTHREE_WEIGHT: " << THREE_WEIGHT;
        std::cout << "\nTWO_WEIGHT: " << TWO_WEIGHT;
        std::cout << "\nDEFAULT_WEIGHT: " << DEFAULT_WEIGHT << "\n";
    }

    void printWeights() {
        std::cout << "SmartestPlayer won the tournament!\n";
    }

    static inline long double evaluateBitBoard( const BitBoard& boardToCheck, const BitBoard& opponentsBoard,  const BitBoard& myOriginalBoard ) {

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
                        resultWeight += FOUR_WEIGHT/2;
                    }
                    if( futureWinPattern2 != 0 && !opponentsBoard.overlapsPattern(futureWinPattern2) ){
                        resultWeight += FOUR_WEIGHT/2;
                    }
                }

                if( future4Pattern2Index != -1 && !opponentsBoard.overlapsPattern(future4Pattern2) ){

                    BoardInt futureWinPattern1 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern2Index][0];
                    BoardInt futureWinPattern2 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern2Index][1];

                    if( !opponentsBoard.overlapsPattern(futureWinPattern1) ){
                        resultWeight += FOUR_WEIGHT/2;
                    }
                    if( futureWinPattern2 != 0 && !opponentsBoard.overlapsPattern(futureWinPattern2) ){
                           resultWeight += FOUR_WEIGHT/2;
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

        for( BoardInt pattern : START_PATTERNS1 ){
            if( boardToCheck.hasPattern(pattern) && !myOriginalBoard.hasPattern(pattern) ){
                resultWeight += PATTERN_WEIGHT1;
            }
        }

        for( BoardInt pattern : START_PATTERNS2 ){
            if( boardToCheck.hasPattern(pattern) && !myOriginalBoard.hasPattern(pattern) ){
                resultWeight += PATTERN_WEIGHT2;
            }
        }

        if( resultWeight != DEFAULT_WEIGHT ){
            return resultWeight;
        }

        for( BoardInt pattern : START_PATTERNS3 ){
            if(  boardToCheck.hasPattern(pattern) && !myOriginalBoard.hasPattern(pattern)  ){
                resultWeight += PATTERN_WEIGHT3;
            }
        }

        if( resultWeight != DEFAULT_WEIGHT ){
            return resultWeight;
        }

        for( BoardInt pattern : START_PATTERNS4 ){
            if( boardToCheck.hasPattern(pattern) && !myOriginalBoard.hasPattern(pattern) ){
                resultWeight += PATTERN_WEIGHT4;
            }
        }

        return resultWeight;

    }


    template<typename T, size_t N>
    static constexpr size_t countof(T (&)[N]) { return N; }

    template< unsigned char level >
    static inline long double getRecursiveWeight( const Board b, const PlayerColor movingPlayersColor, const PlayerColor opponentsColor ){

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

                        long double newMoveWeight;

                        newMoveWeight = evaluateBitBoard(newBoardCopy, opponentsBoard, movingPlayersBoardBeforeTurn );


                        if( level == 1 ){
                            newMoveWeight *= OPPONENT_LEVEL_FACTOR;
                        }

                        Board testBoard;

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
                            newMoveWeight -= (getRecursiveWeight<level + 1>( testBoard, opponentsColor, movingPlayersColor )  * DEFENSE_FACTOR);
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

                        newMoveWeight = evaluateBitBoard(newBoardCopy, opponentsBoard, movingPlayersBoardBeforeTurn );

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
                            newMoveWeight -= (getRecursiveWeight<level + 1>( testBoard2, opponentsColor, movingPlayersColor )  * DEFENSE_FACTOR);
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

    template<Direction direction>
    static inline std::pair<Turn, long double> getMoveParallel (const Board& mainBoard, const PlayerColor myColor, const PlayerColor opponentColor, unsigned int seedRand ){

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

                         long double newMoveWeight;

                         newMoveWeight = evaluateBitBoard( boardToRotate, opponentsBoard, myOriginalBoard );

                         Board testBoard (myColor == BLACK? opponentsBoard:boardToRotate,myColor == BLACK? boardToRotate:opponentsBoard, util.opposite(myColor) );

                         newMoveWeight -= (getRecursiveWeight<1>( testBoard, opponentColor, myColor ) * DEFENSE_FACTOR);


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


    void reset() override {
        moveCount = 0;
    }

    template< unsigned char quadrantA, unsigned char quadrantB >
    static inline bool blockEarlyDiagonal( Turn& bestMove, const BitBoard& opponentsBoard, const MainBoard& mainBoard ){

        bool foundSpecialCase = false;

        if( opponentsBoard.hasPieceAt(quadrantA,0) && mainBoard.holeIsEmpty(quadrantA,8)) {
            foundSpecialCase = true;
            bestMove.setHole({quadrantA,8});
        }
        else if( opponentsBoard.hasPieceAt(quadrantA,8) && mainBoard.holeIsEmpty(quadrantA,0) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantA,0});
        }else if( opponentsBoard.hasPieceAt(quadrantA,2) && mainBoard.holeIsEmpty(quadrantA,6) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantA,6});
        }else if( opponentsBoard.hasPieceAt(quadrantA,6) && mainBoard.holeIsEmpty(quadrantA,2) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantA,2});
        }

        else if( opponentsBoard.hasPieceAt(quadrantB,0) && mainBoard.holeIsEmpty(quadrantB,8)) {
            foundSpecialCase = true;
            bestMove.setHole({quadrantB,8});
        }
        else if( opponentsBoard.hasPieceAt(quadrantB,8) && mainBoard.holeIsEmpty(quadrantB,0) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantB,0});
        }else if( opponentsBoard.hasPieceAt(quadrantB,2) && mainBoard.holeIsEmpty(quadrantB,6) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantB,6});
        }else if( opponentsBoard.hasPieceAt(quadrantB,6) && mainBoard.holeIsEmpty(quadrantB,2) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantB,2});
        }

        return foundSpecialCase;
    }

    template< unsigned char quadrantA, unsigned char quadrantB >
    static inline bool blockEarly( Turn& bestMove, const BitBoard& opponentsBoard, const MainBoard& mainBoard ){

        bool foundSpecialCase = false;

        if( opponentsBoard.hasPieceAt(quadrantA,1) && mainBoard.holeIsEmpty(quadrantA,7)) {
            foundSpecialCase = true;
            bestMove.setHole({quadrantA,7});
        }
        else if( opponentsBoard.hasPieceAt(quadrantA,7) && mainBoard.holeIsEmpty(quadrantA,1) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantA,1});
        }else if( opponentsBoard.hasPieceAt(quadrantA,3) && mainBoard.holeIsEmpty(quadrantA,5) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantA,5});
        }else if( opponentsBoard.hasPieceAt(quadrantA,5) && mainBoard.holeIsEmpty(quadrantA,3) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantA,3});
        }

        else if( opponentsBoard.hasPieceAt(quadrantB,1) && mainBoard.holeIsEmpty(quadrantB,7)) {
            foundSpecialCase = true;
            bestMove.setHole({quadrantB,7});
        }
        else if( opponentsBoard.hasPieceAt(quadrantB,7) && mainBoard.holeIsEmpty(quadrantB,1) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantB,1});
        }else if( opponentsBoard.hasPieceAt(quadrantB,3) && mainBoard.holeIsEmpty(quadrantB,5) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantB,5});
        }else if( opponentsBoard.hasPieceAt(quadrantB,5) && mainBoard.holeIsEmpty(quadrantB,3) ){
            foundSpecialCase = true;
            bestMove.setHole({quadrantB,3});
        }

        return foundSpecialCase;
    }


    Turn getMove(const Board& mainBoard) override{
        clock_t begin = clock();

        Turn bestMove;



        BitBoard opponentsBoard = mainBoard.getBoardOfPlayer(opponentColor);

        bool foundSpecialCase = false;

        for( auto centerPair : START_PATTERNS2 ){
            if( opponentsBoard.hasPattern( centerPair )){
                switch( centerPair ){
                    case TOP_PAIR: foundSpecialCase = blockEarly<0,1>(bestMove, opponentsBoard, mainBoard ); break;
                    case BOTTOM_PAIR: foundSpecialCase = blockEarly<2,3>(bestMove, opponentsBoard, mainBoard ); break;
                    case LEFT_PAIR: foundSpecialCase = blockEarly<0,2>(bestMove, opponentsBoard, mainBoard ); break;
                    case RIGHT_PAIR: foundSpecialCase = blockEarly<1,3>(bestMove, opponentsBoard, mainBoard ); break;
                    case LEFT_DIAGONAL_PAIR: foundSpecialCase = blockEarlyDiagonal<0,3>(bestMove, opponentsBoard, mainBoard ); break;
                    case RIGHT_DIAGONAL_PAIR: foundSpecialCase = blockEarlyDiagonal<1,2>(bestMove, opponentsBoard, mainBoard ); break;
                    default: assert(false);
                }

                break;
            }
        }

        if( foundSpecialCase ){
            qDebug() << "******FOUND SPECIAL CASE*******";
            //pieceHole has already been set

            long double bestRotationWeight = INT_MIN;


            BitBoard myBoard = mainBoard.getBoardOfPlayer(myColor);
            bool beenThroughOnce = false;
            Direction currentDirection = LEFT;
            for( int i = 1; i--; currentDirection = RIGHT ){
                for( unsigned char quadrantToRotate = 4; quadrantToRotate--; ){
                    BitBoard opponentsCopy = opponentsBoard;
                    BitBoard myCopy = myBoard;

                    opponentsCopy.rotate(quadrantToRotate, currentDirection);
                    myCopy.rotate(quadrantToRotate, currentDirection);

                    long double checkWeight = evaluateBitBoard(myCopy, opponentsCopy, myBoard);

                    if( checkWeight > bestRotationWeight ){
                        bestMove.setQuadrantToRotate(quadrantToRotate);
                        bestMove.setRotationDirection(currentDirection);
                        bestRotationWeight = checkWeight;
                    }
                }
            }

            bestMove.setPieceColor(myColor);
        }
        else{

            QFuture< std::pair<Turn, long double> > futureLeft;
            QFuture< std::pair<Turn, long double> > futureRight;

            futureLeft = QtConcurrent::run(getMoveParallel<LEFT>, mainBoard, myColor, opponentColor, qrand() );
            futureRight = QtConcurrent::run(getMoveParallel<RIGHT>, mainBoard, myColor, opponentColor, qrand() );

            std::pair<Turn, long double> resultLeft = futureLeft.result();
            std::pair<Turn, long double> resultRight = futureRight.result();

            if( resultRight.second > resultLeft.second ){
                bestMove = resultRight.first;
            }
            else {
                bestMove = resultLeft.first;
            }
        }

        clock_t end = clock();
        double elapsed_secs = double(end - begin) / CLOCKS_PER_SEC;

        if( elapsed_secs > my_longest_time ){
            std::cout << "\nnew longest time: " << elapsed_secs << " seconds\n";
            my_longest_time = elapsed_secs;

        }
        ++moveCount;
        return bestMove;

    }

};


#endif // CONCURRENTSMARTESTPLAYER_H
