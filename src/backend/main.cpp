#include "PentagoExceptions.h"
#include "GuiGameController.h"
//#include "MonteCarloAI.h"
//#include "MonteCarloAI3.h"
#include "MonteCarloParallelAI.h"
#include "AlphaBetaAI.h"
#include "NetworkInterface.h"
#include <time.h>

#include <QDebug>
#include <QThread>
#include <QQuickItem>
#include <QQuickView>
#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QtQml>
#include <QGlobal.h>
#include <QTime>



typedef GuiGameController GameController;




int main(int argc, char* argv[])
{

    QGuiApplication app (argc, argv);
    app.setOrganizationName("Team 2");
    app.setApplicationName("Pentago");

    QThread testLocal;
    QThread* coreThread = &testLocal; //new QThread;

    GameController gameController( &app );
    gameController.moveToThread(coreThread);
    coreThread->start();

    QQuickView window;
    window.setResizeMode(QQuickView::SizeRootObjectToView);
    window.setSource( QUrl("qrc:/main.qml") );

    GuiProxy proxy( &gameController, qobject_cast<QQuickItem*>(window.rootObject()) );
    window.rootContext() -> setContextProperty( "gameController", &proxy );

    gameController.setWindow( &proxy );

    QMetaObject::invokeMethod( &gameController, "initialize", Qt::QueuedConnection );

    window.showFullScreen();

    return app.exec();
}
