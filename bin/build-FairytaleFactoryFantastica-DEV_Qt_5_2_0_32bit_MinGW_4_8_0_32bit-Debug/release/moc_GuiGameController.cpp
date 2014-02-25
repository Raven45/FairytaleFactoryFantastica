/****************************************************************************
** Meta object code from reading C++ file 'GuiGameController.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.2.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/backend/core/GuiGameController.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#include <QtCore/QList>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'GuiGameController.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.2.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_GuiGameController_t {
    QByteArrayData data[44];
    char stringdata[708];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    offsetof(qt_meta_stringdata_GuiGameController_t, stringdata) + ofs \
        - idx * sizeof(QByteArrayData) \
    )
static const qt_meta_stringdata_GuiGameController_t qt_meta_stringdata_GuiGameController = {
    {
QT_MOC_LITERAL(0, 0, 17),
QT_MOC_LITERAL(1, 18, 14),
QT_MOC_LITERAL(2, 33, 0),
QT_MOC_LITERAL(3, 34, 10),
QT_MOC_LITERAL(4, 45, 15),
QT_MOC_LITERAL(5, 61, 23),
QT_MOC_LITERAL(6, 85, 17),
QT_MOC_LITERAL(7, 103, 17),
QT_MOC_LITERAL(8, 121, 17),
QT_MOC_LITERAL(9, 139, 17),
QT_MOC_LITERAL(10, 157, 17),
QT_MOC_LITERAL(11, 175, 25),
QT_MOC_LITERAL(12, 201, 11),
QT_MOC_LITERAL(13, 213, 17),
QT_MOC_LITERAL(14, 231, 10),
QT_MOC_LITERAL(15, 242, 7),
QT_MOC_LITERAL(16, 250, 18),
QT_MOC_LITERAL(17, 269, 18),
QT_MOC_LITERAL(18, 288, 17),
QT_MOC_LITERAL(19, 306, 14),
QT_MOC_LITERAL(20, 321, 8),
QT_MOC_LITERAL(21, 330, 13),
QT_MOC_LITERAL(22, 344, 4),
QT_MOC_LITERAL(23, 349, 30),
QT_MOC_LITERAL(24, 380, 4),
QT_MOC_LITERAL(25, 385, 24),
QT_MOC_LITERAL(26, 410, 14),
QT_MOC_LITERAL(27, 425, 6),
QT_MOC_LITERAL(28, 432, 6),
QT_MOC_LITERAL(29, 439, 18),
QT_MOC_LITERAL(30, 458, 16),
QT_MOC_LITERAL(31, 475, 17),
QT_MOC_LITERAL(32, 493, 24),
QT_MOC_LITERAL(33, 518, 8),
QT_MOC_LITERAL(34, 527, 36),
QT_MOC_LITERAL(35, 564, 30),
QT_MOC_LITERAL(36, 595, 19),
QT_MOC_LITERAL(37, 615, 17),
QT_MOC_LITERAL(38, 633, 14),
QT_MOC_LITERAL(39, 648, 16),
QT_MOC_LITERAL(40, 665, 10),
QT_MOC_LITERAL(41, 676, 9),
QT_MOC_LITERAL(42, 686, 13),
QT_MOC_LITERAL(43, 700, 6)
    },
    "GuiGameController\0badMoveFromGui\0\0"
    "gameIsOver\0readyForGuiMove\0"
    "waitingForOpponentsMove\0challengeReceived\0"
    "challengeAccepted\0challengeDeclined\0"
    "setGuiPlayerColor\0menuSelectedColor\0"
    "setFirstMovingPlayerColor\0PlayerColor\0"
    "playerToMoveFirst\0setPlayer2\0Player*\0"
    "startOnePersonPlay\0startTwoPersonPlay\0"
    "enterNetworkLobby\0togglePlayback\0"
    "exitGame\0setPlayerName\0name\0"
    "registerOpponentsTurnWithBoard\0Turn\0"
    "registerGuiTurnWithBoard\0setGuiTurnHole\0"
    "qIndex\0pIndex\0setGuiTurnRotation\0"
    "quadrantToRotate\0rotationDirection\0"
    "forwardChallengeResponse\0accepted\0"
    "challengeResponseReceivedFromNetwork\0"
    "networkTurnReceivedFromNetwork\0"
    "setNetworkInterface\0NetworkInterface*\0"
    "backToMainMenu\0getOpponentsTurn\0"
    "QList<int>\0getWinner\0opponentsTurn\0"
    "winner\0"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_GuiGameController[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      27,   14, // methods
       2,  208, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       7,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,  149,    2, 0x06,
       3,    0,  150,    2, 0x06,
       4,    0,  151,    2, 0x06,
       5,    0,  152,    2, 0x06,
       6,    0,  153,    2, 0x06,
       7,    0,  154,    2, 0x06,
       8,    0,  155,    2, 0x06,

 // slots: name, argc, parameters, tag, flags
       9,    1,  156,    2, 0x0a,
      11,    1,  159,    2, 0x0a,
      14,    1,  162,    2, 0x0a,
      16,    0,  165,    2, 0x0a,
      17,    0,  166,    2, 0x0a,
      18,    0,  167,    2, 0x0a,
      19,    0,  168,    2, 0x0a,
      20,    0,  169,    2, 0x0a,
      21,    1,  170,    2, 0x0a,
      23,    1,  173,    2, 0x0a,
      25,    0,  176,    2, 0x0a,
      26,    2,  177,    2, 0x0a,
      29,    2,  182,    2, 0x0a,
      32,    1,  187,    2, 0x0a,
      34,    1,  190,    2, 0x0a,
      35,    4,  193,    2, 0x0a,
      36,    1,  202,    2, 0x0a,
      38,    0,  205,    2, 0x0a,

 // methods: name, argc, parameters, tag, flags
      39,    0,  206,    2, 0x02,
      41,    0,  207,    2, 0x02,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void, QMetaType::Int,   10,
    QMetaType::Void, 0x80000000 | 12,   13,
    QMetaType::Void, 0x80000000 | 15,    2,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QVariant,   22,
    QMetaType::Void, 0x80000000 | 24,    2,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int, QMetaType::Int,   27,   28,
    QMetaType::Void, QMetaType::Int, QMetaType::Int,   30,   31,
    QMetaType::Void, QMetaType::Bool,   33,
    QMetaType::Void, QMetaType::Bool,    2,
    QMetaType::Void, QMetaType::Int, QMetaType::Int, QMetaType::Int, QMetaType::Int,    2,    2,    2,    2,
    QMetaType::Void, 0x80000000 | 37,    2,
    QMetaType::Void,

 // methods: parameters
    0x80000000 | 40,
    QMetaType::Int,

 // properties: name, type, flags
      42, 0x80000000 | 40, 0x00095009,
      43, QMetaType::Int, 0x00095001,

       0        // eod
};

void GuiGameController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        GuiGameController *_t = static_cast<GuiGameController *>(_o);
        switch (_id) {
        case 0: _t->badMoveFromGui(); break;
        case 1: _t->gameIsOver(); break;
        case 2: _t->readyForGuiMove(); break;
        case 3: _t->waitingForOpponentsMove(); break;
        case 4: _t->challengeReceived(); break;
        case 5: _t->challengeAccepted(); break;
        case 6: _t->challengeDeclined(); break;
        case 7: _t->setGuiPlayerColor((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 8: _t->setFirstMovingPlayerColor((*reinterpret_cast< PlayerColor(*)>(_a[1]))); break;
        case 9: _t->setPlayer2((*reinterpret_cast< Player*(*)>(_a[1]))); break;
        case 10: _t->startOnePersonPlay(); break;
        case 11: _t->startTwoPersonPlay(); break;
        case 12: _t->enterNetworkLobby(); break;
        case 13: _t->togglePlayback(); break;
        case 14: _t->exitGame(); break;
        case 15: _t->setPlayerName((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 16: _t->registerOpponentsTurnWithBoard((*reinterpret_cast< Turn(*)>(_a[1]))); break;
        case 17: _t->registerGuiTurnWithBoard(); break;
        case 18: _t->setGuiTurnHole((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 19: _t->setGuiTurnRotation((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 20: _t->forwardChallengeResponse((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 21: _t->challengeResponseReceivedFromNetwork((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 22: _t->networkTurnReceivedFromNetwork((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3])),(*reinterpret_cast< int(*)>(_a[4]))); break;
        case 23: _t->setNetworkInterface((*reinterpret_cast< NetworkInterface*(*)>(_a[1]))); break;
        case 24: _t->backToMainMenu(); break;
        case 25: { QList<int> _r = _t->getOpponentsTurn();
            if (_a[0]) *reinterpret_cast< QList<int>*>(_a[0]) = _r; }  break;
        case 26: { int _r = _t->getWinner();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 23:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< NetworkInterface* >(); break;
            }
            break;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (GuiGameController::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&GuiGameController::badMoveFromGui)) {
                *result = 0;
            }
        }
        {
            typedef void (GuiGameController::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&GuiGameController::gameIsOver)) {
                *result = 1;
            }
        }
        {
            typedef void (GuiGameController::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&GuiGameController::readyForGuiMove)) {
                *result = 2;
            }
        }
        {
            typedef void (GuiGameController::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&GuiGameController::waitingForOpponentsMove)) {
                *result = 3;
            }
        }
        {
            typedef void (GuiGameController::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&GuiGameController::challengeReceived)) {
                *result = 4;
            }
        }
        {
            typedef void (GuiGameController::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&GuiGameController::challengeAccepted)) {
                *result = 5;
            }
        }
        {
            typedef void (GuiGameController::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&GuiGameController::challengeDeclined)) {
                *result = 6;
            }
        }
    } else if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 0:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QList<int> >(); break;
        }
    }

}

const QMetaObject GuiGameController::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_GuiGameController.data,
      qt_meta_data_GuiGameController,  qt_static_metacall, 0, 0}
};


const QMetaObject *GuiGameController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *GuiGameController::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_GuiGameController.stringdata))
        return static_cast<void*>(const_cast< GuiGameController*>(this));
    if (!strcmp(_clname, "GameCore"))
        return static_cast< GameCore*>(const_cast< GuiGameController*>(this));
    return QObject::qt_metacast(_clname);
}

int GuiGameController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 27)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 27;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 27)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 27;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QList<int>*>(_v) = getOpponentsTurn(); break;
        case 1: *reinterpret_cast< int*>(_v) = getWinner(); break;
        }
        _id -= 2;
    } else if (_c == QMetaObject::WriteProperty) {
        _id -= 2;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 2;
    } else if (_c == QMetaObject::RegisterPropertyMetaType) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void GuiGameController::badMoveFromGui()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void GuiGameController::gameIsOver()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void GuiGameController::readyForGuiMove()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}

// SIGNAL 3
void GuiGameController::waitingForOpponentsMove()
{
    QMetaObject::activate(this, &staticMetaObject, 3, 0);
}

// SIGNAL 4
void GuiGameController::challengeReceived()
{
    QMetaObject::activate(this, &staticMetaObject, 4, 0);
}

// SIGNAL 5
void GuiGameController::challengeAccepted()
{
    QMetaObject::activate(this, &staticMetaObject, 5, 0);
}

// SIGNAL 6
void GuiGameController::challengeDeclined()
{
    QMetaObject::activate(this, &staticMetaObject, 6, 0);
}
QT_END_MOC_NAMESPACE
