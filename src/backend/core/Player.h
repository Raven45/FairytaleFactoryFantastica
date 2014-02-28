#ifndef PLAYER_H
#define PLAYER_H

#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include <string>
#include <cassert>
#include <ctime>
#include "MainBoard.h"
#include <QDebug>

class Player {

protected:
    PlayerColor myColor;
    PlayerColor opponentColor;

public:

    virtual ~Player(){}

    Player() : myColor(PlayerColor::NONE), opponentColor(PlayerColor::NONE){
    }

    virtual Turn getMove(const Board& b) = 0;

signals:

    void setColor( const PlayerColor& pc ){
        myColor = pc;
        opponentColor = util.opposite(myColor);
    }

    PlayerColor getColor() const {
        return myColor;
    }

};


#endif
