#ifndef LOCATION_H
#define LOCATION_H


struct BoardLocation{


    //12
    //34
    int quadrantIndex;

    //012
    //345
    //678
    int pieceIndex;

    static const int BAD_LOCATION = -555;

};


#endif // LOCATION_H
