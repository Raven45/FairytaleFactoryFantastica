#ifndef PENTAGOEXCEPTIONS_H
#define PENTAGOEXCEPTIONS_H

#include <exception>
#include <QDebug>
#include "Turn.h"

class InvalidMoveException : std::exception {
public:

    const Turn badMove;

    InvalidMoveException( Turn bad ):badMove(bad){

        #if PENTAGO_RELEASE == true
        Direction rotationDirection = badMove.getRotationDirection();
        PlayerColor pc = badMove.getPieceColor();

        const char* rotationDirectionStr =  rotationDirection  == Direction::LEFT ?
                    "LEFT" : rotationDirection == Direction::RIGHT ?
                        "RIGHT" : itoa(rotationDirection);

        const char* playerStr =  pc  == PlayerColor::WHITE ?
                    "WHITE" : pc == PlayerColor::BLACK ?
                        "BLACK" : itoa(pc);



        qDebug << "bad move at " << badMove.getHole() << " with quadrant " <<
               badMove.getQuadrantToRotate() << " rotating " << rotationDirectionStr <<
                  " by player " << playerStr << '\n';
        #endif

    }

    const char* what() const noexcept override {

        return "An invalid move was submitted to the board. See qDebug() console for details.";
    }
};

#endif
