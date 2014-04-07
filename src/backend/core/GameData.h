#ifndef GAMEDATA_H
#define GAMEDATA_H

#include "WinningAlignment.h"
#include "PlayerColor.h"
#include "BoardLocation.h"

struct GameData{
    bool isDraw;
    WinningAlignment alignment;
    PlayerColor winner;
    PlayerColor lastMover;
    BoardLocation startPiece;
    BoardLocation endPiece;
};

#endif // GAMEDATA_H
