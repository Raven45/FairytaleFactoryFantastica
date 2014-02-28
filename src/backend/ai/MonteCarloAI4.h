#ifndef MONTECARLOAI4_H
#define MONTECARLOAI4_H


#include "Player.h"


#define MAX_PIECES_ON_BOARD 36
#define MAX_PIECES_ON_QUADRANT 9
#define NUMBER_OF_POSSIBLE_ROTATIONS 8
#define NUMBER_OF_QUADRANTS 4
#define MAX_DEPTH_LEVEL 3

#include<map>

#define NUMBER_OF_GAMES_TO_PLAY3 30000

class MonteCarloAI4 : public Player {
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
        int level = 0;
        //play a single game
        do{
            placeRandomPiece (player, current, opponent);

            int quadrantToRotate = rand() % 4;
            Direction rotationDirection = rand() % 2 == 0? LEFT : RIGHT;
            current.rotate(quadrantToRotate, rotationDirection);
            opponent.rotate(quadrantToRotate, rotationDirection);


            if( current.didWin() )
                return 1;
            if( opponent.didWin() )
                return -1;

            player = !player;
            ++level;
        }while( level < 15 && !boardIsFull(current, opponent) );

        return 0;
    }


    static inline Turn monteCarlo ( const Board& mainBoard ){



        signed int bestweight = INT_MIN;
        int bestquadrantIndex, bestpieceIndex;
        unsigned char besti;
        Direction bestd;

        std::map <std::pair<BoardInt,BoardInt>,int> encountered;

        const PlayerColor myColor = mainBoard.turnColor();
        const BitBoard myOriginalBoard = mainBoard.getBoardOfPlayer(myColor);
        const BitBoard myOponnentOriginalBoard = mainBoard.getBoardOfPlayer(util.opposite(myColor));

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

                       if( encountered[ std::make_pair(currentcopy,opponentcopy) ] == 0 ){

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
                               t.setQuadrantToRotate(besti);
                               t.setRotationDirection(bestd);
                               return t;
                           }


                            signed int winWeight = 0;

                            for (int playthrough = 0; playthrough < NUMBER_OF_GAMES_TO_PLAY3; ++playthrough){
                                winWeight += playThroughWin( currentcopy, opponentcopy );
                            }

                            if( winWeight > bestweight ){
                                bestweight = winWeight;
                                bestquadrantIndex = quadrantIndex;
                                bestpieceIndex = pieceIndex;
                                besti = quadrantToRotate;
                                bestd = rotationDirection;
                            }
                       }
                       else{
                           encountered[ std::make_pair(currentcopy,opponentcopy) ] ++;
                       }
                    }
                }
            }
        }


        Turn t;

        BoardLocation bl;
        bl.pieceIndex = bestpieceIndex;
        bl.quadrantIndex = bestquadrantIndex;
        t.setHole(bl);
        t.setPieceColor(myColor);
        t.setQuadrantToRotate(besti);
        t.setRotationDirection(bestd);

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
