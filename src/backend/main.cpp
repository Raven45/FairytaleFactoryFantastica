#include "SmarterPlayer.h"
#include "PentagoExceptions.h"
#include "GuiGameController.h"
#include "SmarterPlayer.h"
#include "MonteCarloAI3.h"
#include "NetworkInterface.h"
#include <time.h>

/*
#include <QtCore/qdebug.h>
#include <QtCore/qthread.h>
#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickview.h>
#include <QtGui/qguiapplication.h>
#include <QtQml/qqmlengine.h>
#include <QtQml/qqmlcomponent.h>
#include <QtQml/qqmlcontext.h>
#include <QtCore/qurl.h>
*/

#include <QDebug>
#include <QThread>
#include <QQuickItem>
#include <QQuickView>
#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QtQml>

typedef MonteCarloAI3 AIPlayer;
typedef GuiGameController GameController;

int main(int argc, char* argv[])
{
    srand(time(0));

    QGuiApplication app (argc, argv);
    app.setOrganizationName("Team 2");
    app.setApplicationName("Pentago");

    //put this on a thread later?
    AIPlayer aiPlayer;
    GameController gameController( &app );
    gameController.setPlayer2( &aiPlayer );

    QQuickView window;
    window.rootContext() -> setContextProperty( "gameController", &gameController );
    window.setSource( QUrl("qrc:/main.qml") );

    gameController.setWindow( &window );

    //put this on a thread later
    NetworkInterface myInterface;
    gameController.setNetworkInterface(&myInterface);

    window.show();

    return app.exec();
}
