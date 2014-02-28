#ifndef MONTECARLOAI2_H
#define MONTECARLOAI2_H

#include "Player.h"


#define MAX_PIECES_ON_BOARD 36
#define MAX_PIECES_ON_QUADRANT 9
#define NUMBER_OF_POSSIBLE_ROTATIONS 8
#define NUMBER_OF_QUADRANTS 4
#define MAX_DEPTH_LEVEL 3

#define NUMBER_OF_GAMES_TO_PLAY 2000

struct BestMove{
    long double score;
    int quadrantIndex, pieceIndex;
    unsigned char i;
    Direction d;
};

class MonteCarloAI2 : public Player{
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

    static inline long double playThroughWin(BitBoard current, BitBoard opponent, const PlayerColor AIColor){

        bool player = false;
        char depth = 1;
        //play a single game
        do{
            placeRandomPiece (player, current, opponent);

            int quadrantToRotate = rand() % 4;
            Direction rotationDirection = rand() % 2 == 0? LEFT : RIGHT;
            current.rotate(quadrantToRotate, rotationDirection);
            opponent.rotate(quadrantToRotate, rotationDirection);
            player = !player;
            ++depth;

        }while( !current.didWin() && !opponent.didWin() && !boardIsFull(current, opponent) );

        long double playthroughscore;

        //OPT: try returning immediately
        if ( current.didWin() ){

            //OPT: try unrolling for each case without pow
            if( depth < 5 ){
                long double weight = (1000000000 / pow(36, depth));
                playthroughscore = weight * weight;
            }
            else{
                playthroughscore = 1;
            }

        }else if ( opponent.didWin() ){

            if( depth < 5 ){
                long double weight = (1000000000 / pow(36, depth));
                playthroughscore = weight * weight * -1;
            }
            else{
                playthroughscore = -1;
            }

        }else if (AIColor == BLACK){
            playthroughscore = 1;
        }
        else{
            playthroughscore = 0;
        }
        return playthroughscore;
    }

    static inline Turn monteCarlo ( const Board& mainBoard ){
        const BitBoard myOriginalBoard = mainBoard.getBoardOfPlayer(mainBoard.turnColor());
        const BitBoard myOponnentOriginalBoard = mainBoard.getBoardOfOpponent(mainBoard.turnColor());
        BestMove bestmove;
        const PlayerColor myColor = mainBoard.turnColor();
        bestmove.score = std::numeric_limits<long double>::min();

        for (int quadrantIndex = 0; quadrantIndex < NUMBER_OF_QUADRANTS; ++quadrantIndex){
            for (int pieceIndex = 0; pieceIndex < MAX_PIECES_ON_QUADRANT; ++pieceIndex){

                if (!myOriginalBoard.hasPieceAt(quadrantIndex, pieceIndex) &&
                    !myOponnentOriginalBoard.hasPieceAt(quadrantIndex, pieceIndex)){

                    for (int rotations = 0; rotations < 8; ++rotations){

                        BitBoard currentcopy = myOriginalBoard;
                        BitBoard opponentcopy = myOponnentOriginalBoard;

                        currentcopy.placePiece( quadrantIndex, pieceIndex );

                        unsigned char quadrantToRotate = rotations % 4;
                        Direction rotationDirection = rotations > 4? LEFT : RIGHT;
                        rotate(quadrantToRotate, rotationDirection, currentcopy, opponentcopy );

                        long double score = 0;
                        for (int playthrough = 0; playthrough < NUMBER_OF_GAMES_TO_PLAY; ++playthrough){
                             score += playThroughWin(currentcopy, opponentcopy, myColor);
                        }
                        if (score > bestmove.score){
                            bestmove.score = score;
                            bestmove.quadrantIndex = quadrantIndex;
                            bestmove.pieceIndex = pieceIndex;
                            bestmove.i = quadrantToRotate;
                            bestmove.d = rotationDirection;
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
    static inline Turn getMove(const Board& mainBoard) override{
        return monteCarlo(mainBoard);
    }
};

#endif // MONTECARLOAI2_H
