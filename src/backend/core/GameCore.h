#ifndef GAMECORE_H
#define GAMECORE_H

#include "GameData.h"
#include "MainBoard.h"



class GameCore {

public:
    void registerTurnWithBoard( Turn playersMove );
    void setMovingPlayerColor( PlayerColor mover );

private:

    Board currentBoard;

protected:

    GameData gameData;

    Board copyCurrentBoard();
    virtual void startNewGame();
    bool isGameOver() const;


};






#endif // GAMECORE_H
