#ifndef MAINBOARD_H
#define MAINBOARD_H

#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include <string>
#include <cassert>

#include "BoardLocation.h"
#include "GameData.h"
#include "Turn.h"
#include "BitBoard.h"

#include <QDebug>


class MainBoard {


public:

    MainBoard();
    MainBoard( const BitBoard& white, const BitBoard& black, PlayerColor mover );
    MainBoard( const MainBoard& );

    GameData        checkWin()                                                      const;
    GameData        checkEarlyWin( BoardLocation partialMove, PlayerColor color )   const;
    PlayerColor     pieceAt (BoardLocation bl)                                      const;
    PlayerColor     pieceAt ( short quadrantIndex, short pieceIndex )               const;
    PlayerColor     turnColor()                                                     const;
    bool            holeIsEmpty( short quadrantIndex, short pieceIndex )            const;
    const BitBoard& getBoardOfPlayer( PlayerColor player )                          const;
    void            print()                                                         const;


    void     setFirstMover( PlayerColor first );
    void            reset();
    bool            move( Turn t ); //returns false if given invalid move



private:

    BitBoard whiteBoard;
    BitBoard blackBoard;
    PlayerColor movingPlayersColor;
};

typedef MainBoard Board;

#endif // MAINBOARD_H
