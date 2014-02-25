
BoardInt convertBinaryBoardToCorrectFormat(BoardInt b){


    /* converting this
     * 0  1  2  3  4  5
     * 6  7  8  9  10 11
     * 12 13 14 15 16 17
     * 18 19 20 21 22 23
     * 24 25 26 27 28 29
     * 30 31 32 33 34 35
     *
     *
     *to this
     * 8  7  6  17 16 15
     * 5  4  3  14 13 12
     * 2  1  0  11 10 9
     * 26 25 24 35 34 33
     * 23 22 21 32 31 30
     * 20 19 18 29 28 27
     *
     */

    /*  0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
     *  8  7  6  17 16 15 5  4  3  14 13 12 2  1  0  11 10 9  26 25 24 35 34 33 23 22 21 32 31 30 20 19 18 29 28 27
     */


    std::bitset<36> original(b);
    std::bitset<36> result;

    int i = 0;
    result[8]  = original[i++];
    result[7]  = original[i++];
    result[6]  = original[i++];
    result[17] = original[i++];
    result[16] = original[i++];
    result[15] = original[i++];
    result[5]  = original[i++];
    result[4]  = original[i++];
    result[3]  = original[i++];
    result[14] = original[i++];
    result[13] = original[i++];
    result[12] = original[i++];
    result[2]  = original[i++];
    result[1]  = original[i++];
    result[0]  = original[i++];
    result[11] = original[i++];
    result[10] = original[i++];
    result[9]  = original[i++];
    result[26] = original[i++];
    result[25] = original[i++];
    result[24] = original[i++];
    result[35] = original[i++];
    result[34] = original[i++];
    result[33] = original[i++];
    result[23] = original[i++];
    result[22] = original[i++];
    result[21] = original[i++];
    result[32] = original[i++];
    result[31] = original[i++];
    result[30] = original[i++];
    result[20] = original[i++];
    result[19] = original[i++];
    result[18] = original[i++];
    result[29] = original[i++];
    result[28] = original[i++];
    result[27] = original[i++];

    return result.to_ullong();

}
