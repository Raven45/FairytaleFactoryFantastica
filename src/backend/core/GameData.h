#ifndef GAMEDATA_H
#define GAMEDATA_H

#include "WinningAlignment.h"
#include "PlayerColor.h"
#include "BoardLocation.h"

struct GameData{
    bool isDraw;
    WinningAlignment alignment;
    PlayerColor winner;
    BoardLocation startPiece;
    BoardLocation endPiece;
};

#endif // GAMEDATA_H
