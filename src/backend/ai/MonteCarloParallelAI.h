#ifndef MONTECARLOPARALLELAI_H
#define MONTECARLOPARALLELAI_H
#include "Player.h"
#include <vector>
#include <omp.h>
using std::vector;

#define MAX_PIECES_ON_BOARD 36
#define MAX_PIECES_ON_QUADRANT 9
#define NUMBER_OF_POSSIBLE_ROTATIONS 8
#define NUMBER_OF_QUADRANTS 4
#define MAX_DEPTH_LEVEL 10
#define NUMBER_OF_GAMES_TO_PLAY 20000
#define NUM_THREADS 8

struct BestMove{
    int score;
    int quadrantIndex, pieceIndex;
    unsigned char i;
    Direction d;
};

struct BoardState{
    BitBoard current;
    BitBoard opponent;
};

class MonteCarloParallelAI : public Player{
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
        int depth = 0;
        do{
            placemove (player, current, opponent);

            int quadrantIndex = rand() % 4;
            Direction rotationDirection = rand() % 2 == 0? LEFT : RIGHT;
            rotate (quadrantIndex, rotationDirection , current, opponent);
            player = !player;
            //heuristic weight for this playthrough
            if (current.didWin())
                return 2;
            if (opponent.didWin())
                return -2;
            if (boardIsFull(current, opponent)){

                if(AIColor == BLACK)
                    return 1;

                return 0;
            }
        }while( ++depth < MAX_DEPTH_LEVEL );

        // true
        //return for running too long
        return 0;

    }

    inline static Turn monteCarlo ( const Board& mainboard ){
        PlayerColor myColor = mainboard.turnColor();
        const BitBoard myOriginalBoard = mainboard.getBoardOfPlayer(myColor);
        const BitBoard myOpponentOriginalBoard = mainboard.getBoardOfPlayer(util.opposite(myColor));
        BestMove bestmove;
        bestmove.score = -5 * NUMBER_OF_GAMES_TO_PLAY;



        vector <BoardState> visited;
        for (int quadrantIndex = 0; quadrantIndex < NUMBER_OF_QUADRANTS; ++quadrantIndex){
            for (int pieceIndex = 0; pieceIndex < MAX_PIECES_ON_QUADRANT; ++pieceIndex){
                if (!myOriginalBoard.hasPieceAt(quadrantIndex, pieceIndex) &&
                    !myOpponentOriginalBoard.hasPieceAt(quadrantIndex, pieceIndex)){

                    for (int rotations = 0; rotations < 8; rotations++){

                        BitBoard currentCopy = myOriginalBoard;
                        BitBoard opponentCopy = myOpponentOriginalBoard;

                        currentCopy.placePiece( quadrantIndex, pieceIndex );
                        rotate(rotations % 4, rotations > 4? LEFT : RIGHT, currentCopy, opponentCopy );

                        BoardState boardState;
                        boardState.current = currentCopy;
                        boardState.opponent = opponentCopy;

                        bool alreadyVisited = false;
                        for (BoardState b : visited){
                            if (b.current == boardState.current && b.opponent == boardState.opponent){
                                alreadyVisited = true;
                            }
                        }

                        if (!alreadyVisited){
                            visited.push_back(boardState);
                        }
                    }
                }
            }
        }


        int score = 0;
        int count = 0;
        omp_set_num_threads(NUM_THREADS);

#pragma omp parallel
        {

#pragma omp for schedule(dynamic, 1)
            for (int iter = 0; iter < visited.size(); iter++){
                BoardState b = visited[iter];
                for (int playthrough = 0; playthrough < NUMBER_OF_GAMES_TO_PLAY; ++playthrough){
                     int thisScore = playthroughWin(b.current, b.opponent, myColor);

#pragma omp atomic
                     score += thisScore;
#pragma omp atomic
                     ++count;
                }
            }
        }

        //qDebug() << count;

        if (score > bestmove.score){
            bestmove.score = score;
            bestmove.quadrantIndex = quadrantIndex;
            bestmove.pieceIndex = pieceIndex;
            bestmove.i = rotations % 4;
            bestmove.d = rotations > 4? LEFT : RIGHT;
        }


        qDebug() << "The total number of games is " << count;
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
        std::clock_t start;
        start = std::clock();
        Turn result = monteCarlo(mainboard);
        qDebug() << "Time: " << ((std::clock() - start) / (double)(CLOCKS_PER_SEC)) << " seconds";
        return result;
    }
};
#endif // MONTECARLOPARALLELAI_H
