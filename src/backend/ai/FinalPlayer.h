#ifndef FINALPLAYER_H
#define FINALPLAYER_H


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


template<unsigned char MAX_EXTRA_LEVELS, bool EASY_MODE = false >
class FinalPlayer : public Player {

    double longestTimeSpentCalculatingMove;

    /*static constexpr long double WIN_WEIGHT =   EASY_MODE? 288 :   27721000;
    static constexpr long double FOUR_WEIGHT =  EASY_MODE? 5   :   91253.4;
    static constexpr long double THREE_WEIGHT = EASY_MODE? 1.1 :   300.393;

    static constexpr long double DEFAULT_WEIGHT = 1;
    static constexpr long double PATTERN_WEIGHT1 = THREE_WEIGHT*THREE_WEIGHT;
    static constexpr long double PATTERN_WEIGHT2 = FOUR_WEIGHT;
    static constexpr long double PATTERN_WEIGHT3 = THREE_WEIGHT/2;
    static constexpr long double PATTERN_WEIGHT4 = THREE_WEIGHT/2;
    //2,2,1,2 = good
    //1.5,2,1,2 = better
    static constexpr long double DEFENSE_FACTOR = 1;
    static constexpr long double EVAL_DEFENSE_FACTOR = 1;
    static constexpr long double OPPONENT_LEVEL_FACTOR = 2.37;*/

    static constexpr long double WIN_WEIGHT =   EASY_MODE? 20 :   100000881000;
    static constexpr long double DEFENSE_FACTOR = 600;



public:

    FinalPlayer():longestTimeSpentCalculatingMove(0){
    }

    static inline long double evaluateBitBoard( const BitBoard& boardToCheck, const BitBoard& opponentsBoard ) {

        long double resultWeight = 0;



        for(unsigned int winIndex = 32; winIndex--; ) {
            const BitBoard winningBoard = WINS[winIndex];
            if( boardToCheck.hasPattern(winningBoard) && !winningBoard.overlapsPattern( opponentsBoard ) ){

                resultWeight += WIN_WEIGHT;
            }
            //account for opponents board
            else if( opponentsBoard.hasPattern(winningBoard) && !winningBoard.overlapsPattern( boardToCheck ) ){
                resultWeight -= WIN_WEIGHT;
            }
        }

        if( resultWeight != 0 ){
            return resultWeight;
        }

        for( unsigned int winIndex = 32; winIndex--;){
            const BoardInt winPattern = WINS[winIndex];
            if( !opponentsBoard.overlapsPattern( winPattern ) ){
                resultWeight += HAMMING_WEIGHT_WEIGHTS[ WIN_PERMUTATION_HAMMING_WEIGHTS[ (winPattern & boardToCheck) ] ];
            }
            else if( !boardToCheck.overlapsPattern( winPattern )){
                resultWeight -= HAMMING_WEIGHT_WEIGHTS[ WIN_PERMUTATION_HAMMING_WEIGHTS[ (winPattern & opponentsBoard) ] ];
            }
        }

        for(unsigned int rotateToWinPatternIndex = 100; rotateToWinPatternIndex--; ){
            const BoardInt rotateToWinPattern = ROTATE_TO_WIN_PATTERNS[rotateToWinPatternIndex];
            if( !opponentsBoard.overlapsPattern( rotateToWinPattern) ){
                resultWeight += HAMMING_WEIGHT_WEIGHTS[ ROTATE_TO_WIN_PERMUTATION_HAMMING_WEIGHTS[ (rotateToWinPattern & boardToCheck) ] ];
            }
            else if( !boardToCheck.overlapsPattern( rotateToWinPattern )){
                resultWeight -= HAMMING_WEIGHT_WEIGHTS[ ROTATE_TO_WIN_PERMUTATION_HAMMING_WEIGHTS[ (rotateToWinPattern & opponentsBoard) ] ];
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

        //backwards loop idiom, possibly uses 1 less register
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

                        newMoveWeight = evaluateBitBoard(newBoardCopy, opponentsBoard );


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
                            newMoveWeight -= (getRecursiveWeight<level + 1>( testBoard, opponentsColor, movingPlayersColor ));
                        }
                        else{
                            //actual opponents level
                            newMoveWeight *= DEFENSE_FACTOR;
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

                        newMoveWeight = evaluateBitBoard(newBoardCopy, opponentsBoard );

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
                            newMoveWeight -= (getRecursiveWeight<level + 1>( testBoard2, opponentsColor, movingPlayersColor ));
                        }

                        else {
                            //actual opponents level
                            newMoveWeight *= DEFENSE_FACTOR;

                            if( newMoveWeight > bestMoveWeight ){
                                bestMoveWeight = newMoveWeight ;
                            }
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

                         newMoveWeight = evaluateBitBoard( boardToRotate, opponentsBoard );

                         Board testBoard (myColor == BLACK? opponentsBoard:boardToRotate,myColor == BLACK? boardToRotate:opponentsBoard, util.opposite(myColor) );

                         if( !EASY_MODE ){
                            newMoveWeight -= (getRecursiveWeight<1>( testBoard, opponentColor, myColor ));
                         }

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

    void printWeights(){
        qDebug() << "Original ConcurrentSmartestPlayer won the tournament.";
    }

    template< unsigned char quadrantA, unsigned char quadrantB >
    static inline bool blockEarlyDiagonal( Turn& bestMove, const BitBoard& opponentsBoard, const MainBoard& mainBoard ){

        //when opponent...

        //... ...
        //... .@.
        //... ...
        //          (or flipped)
        //... ...
        //.@. ...
        //... ...

        //...look for open diagonal pair and block it, if found

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

        //when opponent...

        //... ...
        //.@. .@.
        //... ...
        //          (or similar)
        //... ...
        //... ...
        //... ...

        //...look for open horizontal/vertical pair and block it, if found

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

        if( foundSpecialCase && !EASY_MODE ){

            //pieceHole has already been set by blockEarly or blockEarlyDiagonal function
            qDebug() << "blocking starting move";
            long double bestRotationWeight = INT_MIN;


            const BitBoard myBoard = mainBoard.getBoardOfPlayer(myColor);
            bool beenThroughOnce = false;
            Direction currentDirection = LEFT;
            for( int i = 1; i--; currentDirection = RIGHT ){
                for( unsigned char quadrantToRotate = 4; quadrantToRotate--; ){
                    BitBoard opponentsCopy = opponentsBoard;
                    BitBoard myCopy = myBoard;

                    opponentsCopy.rotate(quadrantToRotate, currentDirection);
                    myCopy.rotate(quadrantToRotate, currentDirection);

                    MainBoard testBoard(myColor == BLACK? opponentsCopy:myCopy,myColor == BLACK? myCopy:opponentsCopy, opponentColor );
                    long double checkWeight = getRecursiveWeight<1>(testBoard, opponentColor, myColor ) * DEFENSE_FACTOR;

                    if( checkWeight > bestRotationWeight || !beenThroughOnce ){
                        bestMove.setQuadrantToRotate(quadrantToRotate);
                        bestMove.setRotationDirection(currentDirection);
                        bestRotationWeight = checkWeight;
                        beenThroughOnce = true;
                    }
                }
            }

            bestMove.setPieceColor(myColor);
        }
        else{
            QFuture< std::pair<Turn, long double> > futureLeft;
            QFuture< std::pair<Turn, long double> > futureRight;

            //divide the work in two, do each in parallel (must be under 6 seconds)
            //qrand() argument adds element of unpredictability to move selection
            //need to call it here from the thread from which qrand was seeded
            futureLeft = QtConcurrent::run(getMoveParallel<LEFT>, mainBoard, myColor, opponentColor, qrand() );
            futureRight = QtConcurrent::run(getMoveParallel<RIGHT>, mainBoard, myColor, opponentColor, qrand() );

            //blocking
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
        double elapsedSeconds = double(end - begin) / CLOCKS_PER_SEC;

        if( elapsedSeconds > longestTimeSpentCalculatingMove ){
            std::cout << "\nnew longest time: " << elapsedSeconds << " seconds\n";
            longestTimeSpentCalculatingMove = elapsedSeconds;

            if( elapsedSeconds >= 5.9 ){
                assert(false);
            }

        }

        return bestMove;

    }

};

#endif // FINALPLAYER_H
