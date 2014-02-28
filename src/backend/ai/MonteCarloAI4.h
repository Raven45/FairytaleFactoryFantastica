#ifndef MONTECARLOAI4_H
#define MONTECARLOAI4_H

#include "Player.h"


#define MAX_PIECES_ON_BOARD 36
#define MAX_PIECES_ON_QUADRANT 9
#define NUMBER_OF_POSSIBLE_ROTATIONS 8
#define NUMBER_OF_QUADRANTS 4

#define NUMBER_OF_GAMES_TO_PLAY4 100000

struct BestMove4{
    signed int weight;
    int quadrantIndex, pieceIndex;
    unsigned char i;
    Direction d;

    BestMove4():weight(INT_MIN){

    }
};

class MonteCarloAI4 : public Player{
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

        do{

            int quadrantIndex, pieceIndex;
            do{
                quadrantIndex = rand() % 4;
                pieceIndex = rand() % 9;

                //OPT: try BitBoard( current | opponent).hasPieceAt( quadrantIndex, pieceIndex )
            }while(current.hasPieceAt(quadrantIndex, pieceIndex) || opponent.hasPieceAt(quadrantIndex, pieceIndex));

            if (player){
                current.placePiece( quadrantIndex, pieceIndex );
            }else{
                opponent.placePiece( quadrantIndex, pieceIndex );
            }

            int quadrantToRotate = rand() % 4;
            Direction rotationDirection = rand() % 2 == 0? LEFT : RIGHT;
            current.rotate(quadrantToRotate, rotationDirection);
            opponent.rotate(quadrantToRotate, rotationDirection);
            player = !player;

        } while( !current.didWin() && !opponent.didWin() && ( (BoardInt)current | (BoardInt)opponent != (BoardInt)FULL_BOARD) );

        if ( current.didWin() )
            return 1;

        if ( opponent.didWin() )
            return -1;

        return 0;
    }


    static inline Turn monteCarlo ( const Board& mainBoard ){

        const PlayerColor myColor = mainBoard.turnColor();
        const BitBoard myOriginalBoard = mainBoard.getBoardOfPlayer(myColor);
        const BitBoard myOponnentOriginalBoard = mainBoard.getBoardOfPlayer(util.opposite(myColor));
        BestMove4 bestmove;

        //qDebug() << "bestmove.weights[0]:" << bestmove.weights[0];

        for (int quadrantIndex = 0; quadrantIndex < NUMBER_OF_QUADRANTS; ++quadrantIndex){

            for (int pieceIndex = 0; pieceIndex < MAX_PIECES_ON_QUADRANT; ++pieceIndex){

                //if (valid move)
                if (!myOriginalBoard.hasPieceAt(quadrantIndex, pieceIndex) && !myOponnentOriginalBoard.hasPieceAt(quadrantIndex, pieceIndex)){


                    for ( int rotations = 0; rotations < 8; ++rotations ) {

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


                        signed int winWeight = 0;

                        for (int playthrough = 0; playthrough < NUMBER_OF_GAMES_TO_PLAY4; ++playthrough){

                            int result = playThroughWin( currentcopy, opponentcopy );
                            winWeight += result;
                        }

                        if( winWeight > bestmove.weight){
                            bestmove.weight = winWeight;
                            bestmove.quadrantIndex = quadrantIndex;
                            bestmove.pieceIndex = pieceIndex;
                            bestmove.i = quadrantToRotate;
                            bestmove.d = rotationDirection;
                            //qDebug() << "found best move!";
                        }
                    }
                }
            }
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
    inline Turn getMove(const Board& mainBoard) override{
        std::clock_t start;
        start = std::clock();
        Turn result = monteCarlo(mainBoard);
        qDebug() << "Time: " << ((std::clock() - start) / (double)(CLOCKS_PER_SEC)) << " seconds";
        return result;
    }
};


#endif // MONTECARLOAI4_H
