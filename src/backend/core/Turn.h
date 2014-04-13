#ifndef TURN_H
#define TURN_H

//#include <cassert>

#include <QDebug>

#include "BoardLocation.h"
#include "Direction.h"
#include "PlayerColor.h"

//used to account for special win condition where there is no rotation
#define DONT_ROTATE_CODE 111
#define TURN_DEBUGGING false



class Turn{
    BoardLocation hole;
    int quadrantToRotate; //0 - 3
    Direction rotationDirection;
    PlayerColor pieceColor;

    static const int EMPTY = -555;

public:
    Turn(){
        //These empty values are only used at the start of a game
        //and never any other time. If at any other time in execution
        //these values are passed, it is a problem.
        hole.pieceIndex = EMPTY;
        hole.quadrantIndex = EMPTY;
        quadrantToRotate = EMPTY;
        rotationDirection = Direction::BAD;
        pieceColor = PlayerColor::NONE;
    }

    Turn( int qIndex, int pIndex, int qToRotate, int rDirection, int pColor = PlayerColor::NONE ){
        //These empty values are only used at the start of a game
        //and never any other time. If at any other time in execution
        //these values are passed, it is a problem.
        hole.pieceIndex = pIndex;
        hole.quadrantIndex = qIndex;
        quadrantToRotate = qToRotate;
        rotationDirection = (Direction)rDirection;
        pieceColor = (PlayerColor)pColor;
    }

    Turn( const Turn& t ){
        hole = t.hole;
        quadrantToRotate = t.quadrantToRotate;
        rotationDirection = t.rotationDirection;
        pieceColor = t.pieceColor;
    }

    //used to check for new game (and possibly check for invalid moves)
    bool isEmpty(){
        return hole.pieceIndex == EMPTY ||
        hole.quadrantIndex == EMPTY ||
        quadrantToRotate == EMPTY ||
        pieceColor == PlayerColor::NONE;
    }

    const BoardLocation& getHole() const {
        if( TURN_DEBUGGING ){
            if ( hole.pieceIndex < 0 || hole.pieceIndex >= 9 ){
                qDebug() << "Error: tried to read bad.getHole().pieceIndex value";
                //assert(false);
            }
            if ( hole.quadrantIndex < 0 || hole.quadrantIndex >= 4 ){
                qDebug() << "Error: tried to read bad.getHole().quadrantIndex value";
                //assert(false);
            }
        }

        return hole;
    }

    const int& getQuadrantToRotate() const {
        if( TURN_DEBUGGING ){

            if ( (quadrantToRotate < 0 || quadrantToRotate >= 4) && quadrantToRotate != DONT_ROTATE_CODE  ){
                qDebug() << "Error: tried to read bad quadrantToRotate value";
                //assert(false);
            }

        }

        return quadrantToRotate;
    }

    const Direction& getRotationDirection() const {
        if( TURN_DEBUGGING ){
            if ( rotationDirection != Direction::LEFT && rotationDirection != Direction::RIGHT && rotationDirection != Direction::NO_DIRECTION ){
                qDebug() << "Error: tried to read bad rotationDirection value";
                //assert(false);
            }
        }

        return rotationDirection;
    }

    const PlayerColor& getPieceColor() const {
        if( TURN_DEBUGGING ){
            if ( pieceColor != PlayerColor::WHITE && pieceColor != PlayerColor::BLACK ){
                qDebug() << "Error: tried to read bad pieceColor value";
                //assert(false);
            }
        }

        return pieceColor;
    }

    void setPieceColor(PlayerColor pc) {
        if( TURN_DEBUGGING ){

            if ( pc != PlayerColor::WHITE && pc != PlayerColor::BLACK ){
                qDebug() << "Error: tried to set turn with bad pieceColor value";
                //assert(false);
            }

        }

        pieceColor = pc;
    }

    void setRotationDirection(Direction rd) {

        if( TURN_DEBUGGING ){
            bool badValue1 = rd != Direction::NO_DIRECTION;
            bool badValue2 = rd != Direction::RIGHT;
            bool badValue3 = rd != Direction::LEFT;

            if ( badValue1 && badValue2 && badValue3 ){
                qDebug() << "Error: tried to set turn with bad rotationDirection value";
                //assert(false);
            }
        }

        rotationDirection = rd;
    }

    void setQuadrantToRotate(int x) {
        if( TURN_DEBUGGING ){
            if ( (x < 0 || x >= 4 ) && x != DONT_ROTATE_CODE ){
                qDebug() << "Error: tried to set turn with bad quadrantToRotate value of " << x;
                //assert(false);
            }
        }

        quadrantToRotate = x;
    }

    void setHole(BoardLocation bl) {
        if( TURN_DEBUGGING ){
            if ( bl.pieceIndex < 0 || bl.pieceIndex >= 9 ){
                qDebug() << "Error: tried to set turn with bad.getHole().pieceIndex value of " << bl.pieceIndex;
                //assert(false);
            }
            if ( bl.quadrantIndex < 0 || bl.quadrantIndex >= 4 ){
                qDebug() << "Error: tried to set turn with bad.getHole().quadrantIndex value of " << bl.quadrantIndex;
                //assert(false);
            }
        }

        hole = bl;
    }






};


#endif // TURN_H
