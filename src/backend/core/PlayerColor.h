#ifndef PLAYERCOLOR_H
#define PLAYERCOLOR_H

enum PlayerColor {
    NONE  = -1,
    WHITE =  0,
    BLACK =  1

};

struct {

    static inline PlayerColor opposite( PlayerColor p ){
        return ((p == PlayerColor::BLACK)? PlayerColor::WHITE : PlayerColor::BLACK);
    }

} util;

#endif // PLAYERCOLOR_H
