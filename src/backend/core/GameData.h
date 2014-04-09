#ifndef GAMEDATA_H
#define GAMEDATA_H

#include "PlayerColor.h"

struct GameData{
    bool isDraw;
    PlayerColor winner;
    PlayerColor lastMover;
};

#endif // GAMEDATA_H
