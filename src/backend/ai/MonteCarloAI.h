#ifndef MONTECARLOAI_H
#define MONTECARLOAI_H
#include "Player.h"
using std::map;

#define MAX_PIECES_ON_BOARD 36
#define MAX_PIECES_ON_QUADRANT 9
#define NUMBER_OF_POSSIBLE_ROTATIONS 8
#define NUMBER_OF_QUADRANTS 4
#define MAX_DEPTH_LEVEL 3

#define NUMBER_OF_GAMES_TO_PLAY 100000

struct BestMove{
    int score;
    int quadrantIndex, pieceIndex;
    unsigned char i;
    Direction d;
};

class MonteCarloAI : public Player{
private:

    inline static void rotate(unsigned char i, Direction d, BitBoard& current, BitBoard& opponent){
        current.rotate(i, d);
        opponent.rotate(i, d);
    }

    inline static bool boardIsFull (BitBoard current, BitBoard opponent){
        bool isFull = false;

        if ( ((BoardInt)current | (BoardInt)opponent) == FULL_BOARD )
            isFull = true;
        return isFull;
    }

    inline static void placemove(bool player, BitBoard& current, BitBoard& opponent){
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

    inline static int playthroughWin(BitBoard current, BitBoard opponent, PlayerColor AIColor){

        bool player = false;

        //play a single game
        do{
            placemove (player, current, opponent);

            int quadrantIndex = rand() % 4;
            Direction rotationDirection = rand() % 2 == 0? LEFT : RIGHT;
            rotate (quadrantIndex, rotationDirection , current, opponent);
            player = !player;
        }while( !current.didWin() && !opponent.didWin() && !boardIsFull(current, opponent) );

        //heuristic weight for this playthrough
        if (current.didWin())
            return 2;
        if (opponent.didWin())
            return -1;
        if (AIColor == BLACK)
            return 1;

        return 0;

    }

    inline static Turn monteCarlo ( const Board& mainboard ){
        PlayerColor myColor = mainboard.turnColor();
        const BitBoard myOriginalBoard = mainboard.getBoardOfPlayer(myColor);
        const BitBoard myOponnentOriginalBoard = mainboard.getBoardOfPlayer(util.opposite(myColor));
        BestMove bestmove;
        bestmove.score = -5 * NUMBER_OF_GAMES_TO_PLAY;

        for (int quadrantIndex = 0; quadrantIndex < NUMBER_OF_QUADRANTS; ++quadrantIndex){
            for (int pieceIndex = 0; pieceIndex < MAX_PIECES_ON_QUADRANT; ++pieceIndex){
                if (!myOriginalBoard.hasPieceAt(quadrantIndex, pieceIndex) &&
                    !myOponnentOriginalBoard.hasPieceAt(quadrantIndex, pieceIndex)){

                    for (int rotations = 0; rotations < 8; rotations++){

                        BitBoard currentcopy = myOriginalBoard;
                        BitBoard opponentcopy = myOponnentOriginalBoard;

                        currentcopy.placePiece( quadrantIndex, pieceIndex );
                        rotate(rotations % 4, rotations > 4? LEFT : RIGHT, currentcopy, opponentcopy );

                        int score = 0;
                        for (int playthrough = 0; playthrough < NUMBER_OF_GAMES_TO_PLAY; ++playthrough){
                             score += playthroughWin(currentcopy, opponentcopy, myColor);
                        }
                        if (score > bestmove.score){
                            bestmove.score = score;
                            bestmove.quadrantIndex = quadrantIndex;
                            bestmove.pieceIndex = pieceIndex;
                            bestmove.i = rotations % 4;
                            bestmove.d = rotations > 4? LEFT : RIGHT;
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
        t.setPieceColor(mainboard.turnColor());
        t.setQuadrantToRotate(bestmove.i);
        t.setRotationDirection(bestmove.d);

        return t;
    }

public:
    inline Turn getMove(const Board& mainboard) override{
        return monteCarlo(mainboard);
    }
};

#endif // MONTECARLOAI_H
