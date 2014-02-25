#ifndef TRANSACTION_H
#define TRANSACTION_H

#include "PentagoNetworkUtil.h"
#include <QByteArray>
#include <QDebug>

using namespace PentagoNetworkUtil;

//these bytes are sent over UDP
//*** IF YOU ALTER MEMBERS YOU MUST ALTER    ***
//*** HOW IT'S CONVERTED TO/FROM QBYTE ARRAY ***
//*** AND THE COPY CONSTRUCTOR               ***
struct Transaction {

    WaxSeal seal;
    NetworkPlayerInfo author;

    enum TransactionType {
        ANNOUNCE = 66,
        CHALLENGE = 77,
        CHALLENGE_RESPONSE = 88,
        NETWORK_TURN = 99
    } transactionType;

    TransactionData data;

    Transaction(){}

    Transaction( NetworkPlayerInfo sender ): author(sender){}

    Transaction( const Transaction& t ) {
        seal = t.seal;
        author = t.author;
        transactionType = t.transactionType;
        data = t.data;
    }

    Transaction( const QByteArray& bytes ){

        assert( bytes.size() == sizeof (Transaction) );

        const char* start = bytes.data();

        seal =          *(WaxSeal*) start;
        start += sizeof  (WaxSeal);

        author =        *(NetworkPlayerInfo*) start;
        start += sizeof  (NetworkPlayerInfo);

        transactionType =   *(TransactionType*) start;
        start += sizeof      (TransactionType);

        data = *(TransactionData*) start;

    }

    QByteArray toByteArray(){
        return QByteArray( (char*) this , sizeof(Transaction) );
    }

    void print(){
        qDebug() << "seal: " << seal;
        author.print();
        qDebug() << "transactionType: " << (int) transactionType;


        switch(transactionType){

            case Transaction::TransactionType::ANNOUNCE:
                qDebug() << "ANNOUNCE processed.";
                break;

        case Transaction::TransactionType::CHALLENGE:
            qDebug() << "CHALLENGE processed.";
            break;

        case Transaction::TransactionType::CHALLENGE_RESPONSE:
            qDebug() << "CHALLENGE_RESPONSE processed.";
            break;

        case Transaction::TransactionType::NETWORK_TURN:
            qDebug() << "NETWORK_TURN processed.";
            break;

            default: qDebug() << "hmm, transactionType error.";
        }
    }



};


typedef Transaction::TransactionType TransactionType;

#endif // TRANSACTION_H
