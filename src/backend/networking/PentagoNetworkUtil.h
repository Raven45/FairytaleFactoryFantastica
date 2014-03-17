#ifndef PENTAGONETWORKUTIL_H
#define PENTAGONETWORKUTIL_H

#include <QStack>
#include <QMap>
#include <QHash>
#include <QHostAddress>

#include "PlayerColor.h"
#include "Turn.h"

#define ALL_INSTANCES QHostAddress::Any
#define ANNOUNCE_PORT       55444
#define GAME_PORT           55445

#define MAX_WAIT_TIME       1800
#define ANNOUNCE_INTERVAL   300
#define MAX_TX_IN_BARRAGE   6
#define BARRAGE_INTERVAL    100

#define SOCKET_RECONNECT_TIMEOUT 500

namespace PentagoNetworkUtil {




    typedef unsigned int PlayerId;


    const int MAX_NETWORK_PEERS = 10;
    const int MAX_PLAYER_NAME_LENGTH = 20;



    enum NetworkPlayerState{
        IN_GAME,
        IDLE
    };


    struct NetworkPlayerInfo{
        PlayerId id;

        quint32 address;

        //NetworkPlayerState state;
        char name[MAX_PLAYER_NAME_LENGTH];

        bool operator == ( const NetworkPlayerInfo& other ) const {
            return id == other.id;
        }

        bool operator > ( const NetworkPlayerInfo& other ) const {
            return id > other.id;
        }

        bool operator < ( const NetworkPlayerInfo& other ) const {
            return id < other.id;
        }

        void print(){
            qDebug() << "id: " << id;
            qDebug() << "name: " << name;
        }

        NetworkPlayerInfo(){
            id = 0;
            address = 0;
            name[0] = '\0';
        }

        NetworkPlayerInfo( const NetworkPlayerInfo& copy ){
            id = copy.id;
            address = copy.address;
            memcpy(name, copy.name, MAX_PLAYER_NAME_LENGTH );
        }

    };



    struct Challenge {

    };


    struct ChallengeResponse {
        bool isAccepted;
    };


    //WaxSeal is a unique number that is used to compare against the previous seal,
    //Like when you know a letter has been opened when its seal is broken
    typedef unsigned int WaxSeal;

    union TransactionData{
        //NetworkPlayerInfo announce;
        Challenge challenge;
        ChallengeResponse challengeResponse;
        Turn turn;

        TransactionData(){}
    };

}



#endif // PENTAGONETWORKUTIL_H
