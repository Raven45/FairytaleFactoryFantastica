#ifndef MONTECARLOAI3_H
#define MONTECARLOAI3_H


#include "Player.h"


#define MAX_PIECES_ON_BOARD 36
#define MAX_PIECES_ON_QUADRANT 9
#define NUMBER_OF_POSSIBLE_ROTATIONS 8
#define NUMBER_OF_QUADRANTS 4
#define MAX_DEPTH_LEVEL 3

#define NUMBER_OF_GAMES_TO_PLAY3 18000

struct BestMove3{
    signed int weights[19];
    int quadrantIndex, pieceIndex;
    unsigned char i;
    Direction d;

    BestMove3():weights{INT_MIN}{

    }
};

class MonteCarloAI3 : public Player{
private:

    static inline bool boardIsFull (const BitBoard& current, const BitBoard& opponent){
        return((BoardInt)current | (BoardInt)opponent) == FULL_BOARD;
    }

    static inline void placeRandomPiece(const bool player, BitBoard& current, BitBoard& opponent){
        int quadrantIndex, pieceIndex;
        do{
            quadrantIndex = rand() % 4;
            pieceIndex = rand() % 9;
        }while(current.hasPieceAt(quadrantIndex, pieceIndex) || opponent.hasPieceAt(quadrantIndex, pieceIndex));

        if (player){
            current.placePiece( quadrantIndex, pieceIndex );
        }else{
            opponent.placePiece( quadrantIndex, pieceIndex );
        }
    }

    static inline int playThroughWin(BitBoard current, BitBoard opponent ){

        bool player = false;
        int level = 1;
        //play a single game
        do{
            placeRandomPiece (player, current, opponent);

            int quadrantToRotate = rand() % 4;
            Direction rotationDirection = rand() % 2 == 0? LEFT : RIGHT;
            current.rotate(quadrantToRotate, rotationDirection);
            opponent.rotate(quadrantToRotate, rotationDirection);

            if( current.didWin() )
                return level;
            if( opponent.didWin() )
                return - level;

            level += player;
            player = !player;

        }while( level < 10 && !boardIsFull(current, opponent) );

        return 0;
    }


    static inline Turn monteCarlo ( const Board& mainBoard ){

        const PlayerColor myColor = mainBoard.turnColor();
        const BitBoard myOriginalBoard = mainBoard.getBoardOfPlayer(myColor);
        const BitBoard myOponnentOriginalBoard = mainBoard.getBoardOfPlayer(util.opposite(myColor));
        BestMove3 bestmove;

        bool moveNeverFound = true;

        qDebug() << "bestmove.weights[0]:" << bestmove.weights[0];

        for (int quadrantIndex = 0; quadrantIndex < NUMBER_OF_QUADRANTS; ++quadrantIndex){

            for (int pieceIndex = 0; pieceIndex < MAX_PIECES_ON_QUADRANT; ++pieceIndex){

                //if (valid move)
                if (!myOriginalBoard.hasPieceAt(quadrantIndex, pieceIndex) && !myOponnentOriginalBoard.hasPieceAt(quadrantIndex, pieceIndex)){



                    for (int rotations = 0; rotations < 8; ++rotations){

                        BitBoard currentcopy = myOriginalBoard;
                        BitBoard opponentcopy = myOponnentOriginalBoard;
                        unsigned char quadrantToRotate = rotations % 4;
                        Direction rotationDirection = rotations > 4? LEFT : RIGHT;

                       currentcopy.placePiece( quadrantIndex, pieceIndex );
                       currentcopy.rotate(quadrantToRotate, rotationDirection);
                       opponentcopy.rotate(quadrantToRotate, rotationDirection);

                       //if opponent wins, don't even bother evaluating
                       if( opponentcopy.didWin() ){
                           break;
                       }

                       //a quick check for win
                       if( currentcopy.didWin() ){
                           Turn t;
                           BoardLocation bl;
                           bl.pieceIndex = pieceIndex;
                           bl.quadrantIndex = quadrantIndex;
                           t.setHole(bl);
                           t.setPieceColor(myColor);
                           t.setQuadrantToRotate(quadrantToRotate);
                           t.setRotationDirection(rotationDirection);
                           return t;
                       }


                        signed int winWeights[19] = {0};

                        for (int playthrough = 0; playthrough < NUMBER_OF_GAMES_TO_PLAY3; ++playthrough){

                            int result = playThroughWin(currentcopy, opponentcopy );

                            if( result > 0 ){
                                ++(winWeights[ result - 1 ]);
                            }
                            else if ( result < 0 ){
                                --(winWeights[ std::abs( result ) - 1 ]);
                            }

                        }


                        bool killLoop = false;

                        /*qDebug() << "for weights at " << quadrantIndex << ", " << pieceIndex << ": " <<
                                    winWeights[0] << ", " <<
                                    winWeights[1] << ", " <<
                                    winWeights[2] << ", " <<
                                    winWeights[3] << ", " <<
                                    winWeights[4] << ", " <<
                                    winWeights[5] << ", " <<
                                    winWeights[6] << ", " <<
                                    winWeights[7] << ", " <<
                                    winWeights[8] << ", " <<
                                    winWeights[9] << ", " <<
                                    winWeights[10];*/

                        //really short loop; can be shorter if we skip to indices according to pieceCount
                        for( int weightIndex = 0; weightIndex < 19; ++weightIndex ){

                            //try adding && winWights[weightIndex] != 0
                            if( winWeights[weightIndex] > bestmove.weights[weightIndex] ){
                                memcpy(bestmove.weights, winWeights, 19);
                                bestmove.quadrantIndex = quadrantIndex;
                                bestmove.pieceIndex = pieceIndex;
                                bestmove.i = quadrantToRotate;
                                bestmove.d = rotationDirection;
                                moveNeverFound = false;
                                break;
                            }
                            else if( winWeights[weightIndex] < bestmove.weights[weightIndex] ){
                                break;
                            }

                        }
                    }
                }
            }
        }


        if( moveNeverFound ){

            int quadrantIndex, pieceIndex;
            do{
                quadrantIndex = rand() % 4;
                pieceIndex = rand() % 9;
            }while( !mainBoard.holeIsEmpty(quadrantIndex, pieceIndex) );

            int quadrantToRotate = rand() % 4;
            Direction rotationDirection = rand() % 2 == 0? LEFT : RIGHT;

            bestmove.quadrantIndex = quadrantIndex;
            bestmove.pieceIndex = pieceIndex;
            bestmove.i = quadrantToRotate;
            bestmove.d = rotationDirection;
        }

        Turn t;

        BoardLocation bl;
        bl.pieceIndex = bestmove.pieceIndex;
        bl.quadrantIndex = bestmove.quadrantIndex;
        t.setHole(bl);
        t.setPieceColor(myColor);
        t.setQuadrantToRotate(bestmove.i);
        t.setRotationDirection(bestmove.d);

        return t;
    }

public:
    inline Turn getMove(const Board& mainBoard) override {
        std::clock_t start;
        start = std::clock() ;
        Turn result = monteCarlo( mainBoard );
        qDebug() << "Time: " << ((std::clock() - start) / (double)(CLOCKS_PER_SEC)) << " seconds";
        return result;
    }
};



#endif // MONTECARLOAI3_H
