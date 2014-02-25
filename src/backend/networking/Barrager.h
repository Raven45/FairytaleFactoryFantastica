#ifndef BARRAGER_H
#define BARRAGER_H

#include <functional>

#include <QTimer>

#include "PentagoNetworkUtil.h"
#include "Transaction.h"

class Barrager : public QObject {

    Q_OBJECT


    std::function<void(Transaction)> sendFunction;
    std::function<void()> onComplete;
    int numberOfSentTxInBarrage;
    Transaction transactionToSend;
    QTimer barrageTimer;


protected slots:
    void sendTransaction(){
        if( numberOfSentTxInBarrage < MAX_TX_IN_BARRAGE ){
            //qDebug() << "sending barrage of " << transactionToSend.transactionType;
            sendFunction( transactionToSend );
            barrageTimer.start(BARRAGE_INTERVAL);
            numberOfSentTxInBarrage++;
        }
        else{
            qDebug() << "calling onComplete after barrage";
            onComplete();
            barrageTimer.stop();
        }
    }

public:
    Barrager( QObject* parent, std::function<void(Transaction)> thisFunctionWritesToASocket )
        : QObject(parent),
          sendFunction(thisFunctionWritesToASocket)
    {
        connect( &barrageTimer, SIGNAL(timeout()), this, SLOT(sendTransaction()) );
    }

    void setTransaction( const Transaction& t ){
        transactionToSend = t;
    }

    void unleash(std::function<void()> fnOnComplete = []{} ){
        qDebug() << "unleashing barrage of tx type " << transactionToSend.transactionType;
        numberOfSentTxInBarrage = 0;
        onComplete = fnOnComplete;
        barrageTimer.start(BARRAGE_INTERVAL);
    }





};




#endif // BARRAGER_H
