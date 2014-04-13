#ifndef BITBOARDUTIL_H
#define BITBOARDUTIL_H


#include <stdint.h>
#include <algorithm>
#include "GameData.h"
#include <bitset>
#include <QDebug>
#include <string>
//#include <cassert>
#include "Direction.h"
#include <map>
#include <initializer_list>

typedef std::uint64_t BoardInt;

template< char FIRST, char... REST >
struct binary{
    static_assert( FIRST == '0' || FIRST == '1', "invalid binary digit" ) ;
    static constexpr BoardInt value = ( ((BoardInt)( ( FIRST - '0' ))) << sizeof...(REST) ) + binary<REST...>::value;
};

template<>
struct binary<'0'> {
    static constexpr BoardInt value = 0 ;
};

template<> struct binary<'1'> {
    static constexpr BoardInt value = 1 ;
};

//user-defined literals _b for binary
template<  char... LITERAL >
inline constexpr BoardInt operator "" _b() {
    static_assert( sizeof...(LITERAL) == 36, "wrong number of chars in board literal" );
    return binary<LITERAL...>::value;
}


typedef std::uint16_t QuadrantInt;


constexpr BoardInt TWO_IN_A_ROW[] = {
    #include "twoInARowArray.cpp"
};

constexpr BoardInt NUMBER_OF_SIGNIFICANT_THREE_IN_A_ROW_PATTERNS = 68;
constexpr BoardInt THREE_IN_A_ROW[ NUMBER_OF_SIGNIFICANT_THREE_IN_A_ROW_PATTERNS ] = {
    #include "threeInARowArray.cpp"
};

constexpr BoardInt NUMBER_OF_SIGNIFICANT_FOUR_IN_A_ROW_PATTERNS = 50;
constexpr BoardInt FOUR_IN_A_ROW[ NUMBER_OF_SIGNIFICANT_FOUR_IN_A_ROW_PATTERNS ] = {
    #include "fourInARowArray.cpp"
};

constexpr unsigned char POSSIBLE_WIN_COUNT = 32;
constexpr BoardInt WINS[POSSIBLE_WIN_COUNT] = {
    #include "Wins.cpp"
};

constexpr QuadrantInt ROTATION_ARRAY[512 * 2] = {
    #include "rotationArray.cpp"
};

constexpr BoardInt THREE_TO_FOUR_IN_A_ROW[ NUMBER_OF_SIGNIFICANT_THREE_IN_A_ROW_PATTERNS ][2] = {
    #include "threeToFourInARowArray.cpp"
};

//this is an array of the indexes to the appropriate fourInARow configuration
//-1 in the [][1] slot means it does not have a second configuration.
constexpr int THREE_TO_FOUR_IN_A_ROW_INDEXES[ NUMBER_OF_SIGNIFICANT_THREE_IN_A_ROW_PATTERNS ][2] = {
    #include "threeToFourInARowIndexesArray.cpp"
};

constexpr BoardInt FOUR_TO_FIVE_IN_A_ROW[ NUMBER_OF_SIGNIFICANT_FOUR_IN_A_ROW_PATTERNS ][2] = {
    #include "fourToFiveInARowArray.cpp"
};

static constexpr BoardInt START_PATTERNS1[] = {16,
                                               4194304,
                                               2147483648,
                                               8192};

static constexpr BoardInt START_PATTERNS2[] = {2147491840,
                                               2151677952,
                                               4194320,
                                               8208,
                                               2147483664,
                                               4202496};

static constexpr BoardInt START_PATTERNS3[] = {6446645248,
                                               2153775104,
                                               2147492864,
                                               19327361024,
                                               8216,
                                               24592,
                                               37748752,
                                               4194322,
                                               36507222032,
                                               20979712,
                                               2147483665,
                                               4204544};

static constexpr BoardInt START_PATTERNS4[] = {19327362048,
                                               6448742400,
                                               37748754,
                                               24600,
                                               36507222033,
                                               20981760
                                              };

static constexpr BoardInt START_PATTERNS_ROTATE_TO_3[] ={19331547136,
                                                         2420113408,
                                                         2152202240,
                                                         2185232384,
                                                         6442459136,
                                                         3221233664,
                                                         2147508224,
                                                         2147495936,
                                                         8210,
                                                         8336,
                                                         73744,
                                                         9232,
                                                         4194328,
                                                         4194352,
                                                         6291472,
                                                         12582928};

static constexpr BoardInt ROTATE_TO_WIN_PATTERNS[] = {
    #include "rotateToWinArray.cpp"
};

static std::map<BoardInt,unsigned int>  ROTATE_TO_WIN_PERMUTATION_HAMMING_WEIGHTS = {
    #include "rotateToWinPermutations.cpp"
};

static std::map<BoardInt,unsigned int>  WIN_PERMUTATION_HAMMING_WEIGHTS = {
    #include "winPermutations.cpp"
};

struct WEIGHTS_CLASS{
static constexpr long double a = 1;
static constexpr long double b = 288;
static constexpr long double c = 288 * b;
static constexpr long double d = 288 * c;
static constexpr long double e = 288 * d;
static constexpr long double f = 288 * e;
static constexpr long double g = 288 * f;
static constexpr long double h = 288 * g;
};

static constexpr long double HAMMING_WEIGHT_WEIGHTS[] = {
    0, WEIGHTS_CLASS::a, WEIGHTS_CLASS::b, WEIGHTS_CLASS::c, WEIGHTS_CLASS::d, WEIGHTS_CLASS::e
};

static constexpr BoardInt START_PATTERNS_ROTATE_TO_4[] = {19333644288,
                                                        2422210560,
                                                        6447169536,
                                                        6480199680,
                                                        6442460160,
                                                        3221234688,
                                                        19327365120,
                                                        19327377408,
                                                        9240,
                                                        73752,
                                                        24594,
                                                        24720,
                                                        37748760,
                                                        37748784,
                                                        12582930,
                                                        6291474,
                                                        10737418257,
                                                        2684354577,
                                                        36507222036,
                                                        36507222096,
                                                        4466688,
                                                        71313408,
                                                        20980224,
                                                        21110784};

typedef std::uint8_t RowInt;

template <BoardInt x>
struct SignificantBits {
    static constexpr BoardInt n = SignificantBits<x/2>::n + 1;
};

template <>
struct SignificantBits<0> {
    static constexpr BoardInt n = 0;
};

constexpr BoardInt FULL_BOARD =
111111111111111111111111111111111111_b;

constexpr BoardInt TOP_PAIR = 2151677952;
constexpr BoardInt BOTTOM_PAIR = 8208;
constexpr BoardInt LEFT_PAIR = 2147491840;
constexpr BoardInt RIGHT_PAIR = 4194320;
constexpr BoardInt LEFT_DIAGONAL_PAIR = 2147483664;
constexpr BoardInt RIGHT_DIAGONAL_PAIR = 4202496;


#endif // BITBOARDUTIL_H
