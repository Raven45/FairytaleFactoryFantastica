
#include "GuiGameController.h"
#include "MonteCarloParallelAI.h"
#include "AlphaBetaAI.h"
#include "NetworkInterface.h"
#include <time.h>

#include <QDebug>
#include <QSharedMemory>
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
    app.setOrganizationName("Muffin Man Studios");
    app.setApplicationName("Fairytale Factory Fantastica");


    app.processEvents();

     QSharedMemory shared("62d68989-bb34-4a24-881b-b64490a1e04");
     if( !shared.create( 512, QSharedMemory::ReadWrite) ){
       qWarning() << "Can't start more than one instance of the application.";
       exit(0);
     }


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
