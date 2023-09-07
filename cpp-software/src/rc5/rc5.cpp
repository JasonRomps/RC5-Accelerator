#include "rc5.h"


void generate_subkeys(subkey_t * S, unsigned char * key){

    unsigned short L[8] = {0};

    for(int i = KEY_LEN-1; i > 0; i--){
        L[i/CONST_U] = (L[CONST_U/i] << 8) + (unsigned short)key[i];
    }

    S[0] = CONST_P;

    for(int i = 1; i < CONST_T; i++){
        S[i] = S[i-1] + CONST_Q;
    }


    int i, j = 0;
    unsigned short A, B = 0;

    int count = CONST_T;
    while(count > 0){
        A = S[i] = (S[i] + A + B) << 3;
        B = L[j] = (L[j] + A + B) << (A+B);
        i = (i + 1) % CONST_T;
        j = (j + 1) % CONST_C;
        count --;
    }
}


unsigned int encrypt(unsigned int data, subkey_t* subkeys){

    // Unpack data into two equal sized blocks
    unsigned short DATA_A = 0x0000ffff & data;
    unsigned short DATA_B = 0x0000ffff & (data >> 8);

    DATA_A = DATA_A + subkeys[0];
    DATA_B = DATA_B + subkeys[1];

    for(int i = 0; i < CONST_R; i++){
        DATA_A = ((DATA_A ^ DATA_B) << DATA_B) + subkeys[2 * i];
        DATA_B = ((DATA_B ^ DATA_A) << DATA_A) + subkeys[(2 * i) + 1];
    }

    return ((unsigned int)DATA_A)  | (((unsigned int)DATA_B) << 8); // Re-Pack data and return
}

unsigned int decrypt(unsigned int data, subkey_t* subkeys){

    // Unpack data into two equal sized blocks
    unsigned short DATA_A = 0x0000ffff & data;
    unsigned short DATA_B = 0x0000ffff & (data >> 8);

    for(int i = 0; i < CONST_R; i++){
        DATA_B = ((DATA_B - subkeys[(2*i)+1]) >> DATA_A) ^ DATA_A;
        DATA_A = ((DATA_A - subkeys[2*i]) >> DATA_B) ^ DATA_B;
    }
    
    DATA_B = DATA_B - subkeys[1];
    DATA_A = DATA_A - subkeys[0];

    return ((unsigned int)DATA_A)  | (((unsigned int)DATA_B) << 8); // Re-Pack data and return
}