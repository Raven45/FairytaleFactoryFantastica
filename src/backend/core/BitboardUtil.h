#ifndef BITBOARDUTIL_H
#define BITBOARDUTIL_H


#include <stdint.h>
#include <algorithm>
#include "GameData.h"
#include <bitset>
#include <QDebug>
#include <string>
#include <cassert>
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

constexpr BoardInt WINS[32] = {
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
                                               8208};

static constexpr BoardInt START_PATTERNS3[] = {6446645248,
                                               2153775104,
                                               2147492864,
                                               19327361024,
                                               8216,
                                               24592,
                                               37748752,
                                               4194322};

static constexpr BoardInt START_PATTERNS4[] = {19327362048,
                                               6448742400,
                                               37748754,
                                               24600};

typedef std::uint8_t RowInt;

constexpr BoardInt FULL_BOARD =
111111111111111111111111111111111111_b;

#endif // BITBOARDUTIL_H
