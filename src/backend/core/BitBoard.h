#ifndef BITBOARD_H
#define BITBOARD_H

#include "BitboardUtil.h"

class BitBoard{

protected:

    BoardInt bitBoard;



    inline void setQuadrant(unsigned char quadrantIndex, QuadrantInt bitValues){

        switch(quadrantIndex){
            case 0:

            bitBoard &= 000000000111111111111111111111111111_b;
            bitBoard |= (((BoardInt)(bitValues)) << 27);
            return;
            case 1:
            bitBoard &= 111111111000000000111111111111111111_b;
            bitBoard |= (((BoardInt)(bitValues)) << 18);
            return;
            case 2:
            bitBoard &= 111111111111111111000000000111111111_b;
            bitBoard |= (((BoardInt)(bitValues)) << 9);
            return;
            case 3:
            bitBoard &= 111111111111111111111111111000000000_b;
            bitBoard |= ((BoardInt)(bitValues));
            return;
        }
    }

    inline QuadrantInt getQuadrant(unsigned char i) const {
        switch(i){
            case 0:
            return (BoardInt)(((BoardInt)(bitBoard & 111111111000000000000000000000000000_b)) >> 27);
            case 1:
            return (BoardInt)(((BoardInt)(bitBoard & 000000000111111111000000000000000000_b)) >> 18);
            case 2:
            return (BoardInt)(((BoardInt)(bitBoard & 000000000000000000111111111000000000_b)) >> 9);
            case 3:
            return  (BoardInt)(bitBoard & 000000000000000000000000000111111111_b);
            default: return 0;
        }
    }

    RowInt getRow (unsigned char i) const {
        switch(i){
        case 0:
            return ((BoardInt)((BoardInt)((BoardInt)(bitBoard & 000000000000000111000000000000000000_b) >> 18) << 3)) | (BoardInt)((BoardInt)(bitBoard & 000000111000000000000000000000000000_b) >> 27);
        case 1:
            return ((BoardInt)(((BoardInt)(BoardInt)((bitBoard & 000000000000111000000000000000000000_b)) >> 21) << 3)) | (BoardInt)((BoardInt)(bitBoard & 000111000000000000000000000000000000_b) >> 30);
        case 2:
            return ((BoardInt)((BoardInt)((BoardInt)(bitBoard & 000000000111000000000000000000000000_b) >> 24) << 3))  | (BoardInt)((BoardInt)(bitBoard & 111000000000000000000000000000000000_b) >> 33);
        case 3:
            return ((BoardInt)((BoardInt)((BoardInt)(bitBoard & 000000000000000000000000000000000111_b))       << 3))  | (BoardInt)((BoardInt)(bitBoard & 000000000000000000000000111000000000_b) >> 9);
        case 4:
            return (BoardInt)((BoardInt)((bitBoard & 000000000000000000000000000000111000_b)))              | (BoardInt)((BoardInt)(bitBoard & 000000000000000000000111000000000000_b) >> 12);
        case 5:
            return ((BoardInt)((BoardInt)((BoardInt)(bitBoard & 000000000000000000000000000111000000_b) >>  6) << 3)) | (BoardInt)((BoardInt)(bitBoard & 000000000000000000111000000000000000_b) >> 15);
            default: return 0;
        }
    }

public:

    BitBoard(){
        bitBoard = 0;
    }

    BitBoard(const BoardInt& b ){
        bitBoard = b;
    }

    inline void reset(){
        bitBoard = 0;
    }

    inline bool hasPattern( const BitBoard& checkForPattern ) const {
        return (bitBoard & checkForPattern) == checkForPattern;
    }

    inline bool overlapsPattern( const BoardInt& pattern ) const {
        return (bitBoard & pattern) > 0;
    }

    inline BitBoard& operator=(const BoardInt& b){
        bitBoard = b;
        return *this;
    }

    inline bool operator != (const BitBoard& b)const{
        return bitBoard != b.bitBoard;
    }

    inline operator BoardInt() const {
        return bitBoard;
    }

    inline void rotate(unsigned char i, Direction d ){
        setQuadrant( i, ROTATION_ARRAY[ getQuadrant(i) + (d == LEFT? 512 : 0) ] );
    }

    inline bool isEmpty() const {
        return bitBoard == 0;
    }

    inline void placePiece(unsigned char quadrantIndex, unsigned char pieceIndex){
        setQuadrant( quadrantIndex, (getQuadrant(quadrantIndex) | (1 << pieceIndex)) );
    }

    inline bool hasPieceAt(unsigned char quadrantIndex, unsigned char pieceIndex) const{
        return getQuadrant(quadrantIndex) == (getQuadrant(quadrantIndex) | (1 << pieceIndex));
    }

    void printBoard() const {
        qDebug() << std::bitset<36>(bitBoard).to_string().c_str();
    }

    //got this code from stack overflow. It just... works.
    std::uint8_t reverse(std::uint8_t b) const {
       b = (b & 0xF0) >> 4 | (b & 0x0F) << 4;
       b = (b & 0xCC) >> 2 | (b & 0x33) << 2;
       b = (b & 0xAA) >> 1 | (b & 0x55) << 1;
       return b;
    }

    std::string print() {
        std::string board = "";
        for (int row = 0; row < 6; row++){
            board += std::bitset<6>( reverse(getRow(row)) >> 2 ).to_string();
            //FRAGILE
            qDebug() << std::bitset<6>( reverse(getRow(row)) >> 2 ).to_string().c_str();
        }
        return board;
    }

    std::string getPrintableRow( unsigned char rowIndex ) const {
        return std::bitset<6>( reverse(getRow(rowIndex)) >> 2 ).to_string();
    }

    inline bool didWin() const {

        for( unsigned char winIndex = POSSIBLE_WIN_COUNT; winIndex--; ){

            BoardInt win = WINS[winIndex];

            if( ( bitBoard & win ) == win ){
                return true;
            }
        }

        return false;
    }


};

#endif // BITBOARD_H
