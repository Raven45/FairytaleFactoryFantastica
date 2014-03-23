#ifndef ALPHABETAAI_H
#define ALPHABETAAI_H

#define MAX_PIECES_ON_BOARD 36
#define MAX_PIECES_ON_QUADRANT 9
#define NUMBER_OF_POSSIBLE_ROTATIONS 8
#define NUMBER_OF_QUADRANTS 4
#define MAX_DEPTH_LEVEL 3
#define NUMBER_GAMES_TO_PLAY 1000

#include <iostream>
using std::cout;
using std::endl;

#include "Player.h"
#include <vector>
#include <algorithm>
using std::max;
using std::min;
using std::vector;

struct Node{
    BitBoard currentPlayer;
    BitBoard opponent;
    int score;
    void rotate(unsigned char q, Direction d){
        currentPlayer.rotate(q, d);
        opponent.rotate(q, d);
    }
};


class AlphaBetaAI : public Player{
private:
    Node root;
    PlayerColor currentPlayerColor;
    //initialize alpha and beta to negative and positive "infinity" values
    int Alpha = -1000000;
    int Beta = 1000000;

    int visits = 0;

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

    inline static void rotate(unsigned char i, Direction d, BitBoard& current, BitBoard& opponent){
        current.rotate(i, d);
        opponent.rotate(i, d);
    }

    inline static int playthroughWin(BitBoard current, BitBoard opponent, PlayerColor AIColor){

        bool player = false;

        //play a single game
        //int depth = 0;
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
        }while( true );

        // ++depth < MAX_DEPTH_LEVEL
        //return for running too long
        return 0;

    }

    inline int evaluateNode(Node n, PlayerColor AIColor){
        //heuristic
        int score;
        for (int i = 0; i < NUMBER_GAMES_TO_PLAY; i++){
            score = playthroughWin(n.currentPlayer, n.opponent, AIColor);
        }
        return score;
    }

    inline vector<Node> generateChildNodes(Node n, bool isMyTurn){
        vector<Node> childNodes;
        for( int quadrantIndex = 0; quadrantIndex < NUMBER_OF_QUADRANTS; ++quadrantIndex ){
            for( int pieceIndex = 0; pieceIndex < MAX_PIECES_ON_QUADRANT; ++pieceIndex){
                if (!n.currentPlayer.hasPieceAt(quadrantIndex, pieceIndex) &&
                    !n.opponent.hasPieceAt(quadrantIndex, pieceIndex)){
                    Node childNode;
                    childNode.currentPlayer = n.currentPlayer;
                    childNode.opponent = n.opponent;
                    if (isMyTurn){
                        if (quadrantIndex == 0 && pieceIndex == 4){
                            ;
                        }
                        childNode.currentPlayer.placePiece(quadrantIndex, pieceIndex);
                    }
                    else{
                        childNode.opponent.placePiece(quadrantIndex, pieceIndex);
                    }

                    //Board without rotation
                    //childNodes.push_back(childNode);

                    for (int rotations = 0; rotations < 8; rotations++){
                        Node copyChildNode = childNode;
                        copyChildNode.rotate(rotations % 4, rotations > 4? LEFT : RIGHT );
                        childNodes.push_back( copyChildNode );
                    }
                }
            }
        }
        return childNodes;
    }

    inline Node ABTreeSearch (int alpha, int beta, Node n, int level, PlayerColor AIColor){

        visits++;
        bool isMaxNode = level % 2 == 0? true : false;
        Node BestNode;

        if (level >= MAX_DEPTH_LEVEL){
            //return h*(n)
            BestNode.currentPlayer = n.currentPlayer;
            BestNode.opponent = n.opponent;
            BestNode.score = evaluateNode(n, AIColor);
            return BestNode;
        }

        vector<Node> childNodes = generateChildNodes(n, isMaxNode);

        //cout << "Node " << visits++ << " with " << childNodes.size() << " children. " << std::endl;

        // determine if is min node or max node

        for ( Node childNode : childNodes ){
            for ( BitBoard win : WINS ){
                if ( (childNode.currentPlayer & win) == win){
                    BestNode.currentPlayer = childNode.currentPlayer;
                    BestNode.opponent = childNode.opponent;
                    BestNode.score = 1000000;
                    return BestNode;
                }
                else if ( (childNode.opponent & win) == win ){
                    BestNode.currentPlayer = childNode.currentPlayer;
                    BestNode.opponent = childNode.opponent;
                    BestNode.score = -900000;
                    return BestNode;
                }
            }
            if ( isMaxNode ){
                int subTreeScore = ABTreeSearch(alpha, beta, childNode, level + 1, AIColor).score;
                alpha = max(alpha, subTreeScore);
                if (alpha >= beta){
                    BestNode.currentPlayer = childNode.currentPlayer;
                    BestNode.opponent = childNode.opponent;
                    BestNode.score = beta;
                    return BestNode;
                }
            }
            else{
                int subTreeScore = ABTreeSearch(alpha, beta, childNode, level + 1, AIColor).score;
                beta = min(beta, subTreeScore);
                if (beta <= alpha){
                    BestNode.currentPlayer = childNode.currentPlayer;
                    BestNode.opponent = childNode.opponent;
                    BestNode.score = alpha;
                    return BestNode;
                }
            }
        }

        BestNode.currentPlayer = childNodes.back().currentPlayer;
        BestNode.opponent = childNodes.back().opponent;
        if (isMaxNode){
            BestNode.score = alpha;
        }
        else{
            BestNode.score = beta;
        }
        return BestNode;
    }

    inline Turn ConvertNodeToTurn (Node root, Node n){
        Turn myTurn;
        myTurn.setPieceColor( this->currentPlayerColor );

        for( int quadrantIndex = 0; quadrantIndex < NUMBER_OF_QUADRANTS; ++quadrantIndex ){
            for( int pieceIndex = 0; pieceIndex < MAX_PIECES_ON_QUADRANT; ++pieceIndex){
                if (!root.currentPlayer.hasPieceAt(quadrantIndex, pieceIndex) &&
                    !root.opponent.hasPieceAt(quadrantIndex, pieceIndex)){
                    Node childNode;
                    childNode.currentPlayer = root.currentPlayer;
                    childNode.opponent = root.opponent;

                    childNode.currentPlayer.placePiece(quadrantIndex, pieceIndex);

                    for (int rotations = 0; rotations < 8; rotations++){
                        Node copyChildNode = childNode;
                        copyChildNode.rotate(rotations % 4, rotations > 4? LEFT : RIGHT );

                        if (copyChildNode.currentPlayer == n.currentPlayer &&
                            copyChildNode.opponent == n.opponent){
                            cout << "get here" << endl;
                            BoardLocation b;
                            b.pieceIndex = pieceIndex;
                            b.quadrantIndex = quadrantIndex;
                            myTurn.setHole( b );
                            myTurn.setQuadrantToRotate( rotations % 4 );
                            myTurn.setRotationDirection( rotations > 4? LEFT : RIGHT );
                            return myTurn;
                        }
                    }
                }
            }
        }

        assert(false);
        return Turn();
    }

public:
    inline int getVisits() {
        return visits;
    }


    inline Turn getMove(const Board& mainboard) override{
        root.currentPlayer = mainboard.getBoardOfPlayer(mainboard.turnColor());
        root.opponent = mainboard.getBoardOfPlayer(mainboard.turnColor() == WHITE? BLACK:WHITE);
        currentPlayerColor = mainboard.turnColor();
        int alpha = -1000000;
        int beta = 1000000;

        root.currentPlayer.print();
        cout << endl;
        root.opponent.print();
        cout << endl << endl;

        Node n = ABTreeSearch(alpha, beta, root, 0, mainboard.turnColor());

        n.currentPlayer.print();
        cout << endl;
        n.opponent.print();
        cout << endl << endl;

        Turn t = ConvertNodeToTurn(root, n);
        return t;
    }
};

#endif // ALPHABETAAI_H
