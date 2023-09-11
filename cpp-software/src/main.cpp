/* RC5REF.C -- Reference implementation of RC5-32/12/16 in C.        */
/* Copyright (C) 1995 RSA Data Security, Inc.                        */

#include <iostream>
#include <iomanip>

/* RC5REF.C -- Reference implementation of RC5-32/12/16 in C.        */
/* Copyright (C) 1995 RSA Data Security, Inc.                        */
typedef unsigned short WORD;       /* Should be 32-bit = 4 bytes
*/
#define w        16             /* word size in bits                 */
#define r        12             /* number of rounds                  */
#define b        16             /* number of bytes in key            */
#define c        ((8*b)/w)             /* number  words in key = ceil(8*b/w)*/
#define t        (2*(r+1))             /* size of table S = 2*(r+1) words   */
WORD S[t];                      /* expanded key table                */

// WORD P = 0xb7e15163, Q = 0x9e3779b9;  /* magic constants             */
WORD P = 0xb7e1, Q = 0x9e37;  /* magic constants             */

/* Rotation operators. x must be unsigned, to get logical right shift*/
// #define ROTL(x,y) (((x)<<(y&(w-1))) | ((x)>>(w-(y&(w-1)))))
// #define ROTR(x,y) (((x)>>(y&(w-1))) | ((x)<<(w-(y&(w-1)))))
WORD ROTL(WORD x, WORD y){
    WORD n = y % 16;
    WORD out = (((x)<<(n)) | ((x)>>(w-n)));
    return out;
}

WORD ROTR(WORD x, WORD y){
    WORD n = y % 16;
    WORD out = (((x)>>(n)) | ((x)<<(w-n)));
    return out;
}

void RC5_ENCRYPT(WORD *pt, WORD *ct){ /* 2 WORD input pt/output ct    */
    WORD i, A=pt[0]+S[0], B=pt[1]+S[1];
    for (i=1; i<=r; i++){
        A = ROTL(A^B, B) + S[2*i];
        B = ROTL(B^A, A) + S[2*i+1];
    }

    ct[0] = A;
    ct[1] = B;
}

void RC5_DECRYPT(WORD *ct, WORD *pt){ /* 2 WORD input ct/output pt    */
    WORD i, B=ct[1], A=ct[0];
    for (i=r; i>0; i--){
        B = ROTR(B-S[2*i+1], A) ^ A;
        A = ROTR(A-S[2*i], B) ^ B;
    }

    pt[1] = B-S[1]; 
    pt[0] = A-S[0];
}

void RC5_SETUP(unsigned char *K) /* secret input key K[0...b-1]      */
{  
    WORD j, k, u=w/8, A, B, L[c];
    int i;
    /* Initialize L, then S, then mix key into S */
    L[c-1] = 0;
    for (i=b-1; i!=-1; i--){
        L[i/u] = (L[i/u] << 8) + K[i];
    }

    for (S[0]=P,i=1; i<t; i++){
        S[i] = S[i-1] + Q;
    }

    A = B = j = k = 0;
    for (i = 0; k < 3*t; k++){   /* 3*t > 3*c */
        A = S[i] = ROTL(S[i]+(A+B),3);
        B = L[j] = ROTL(L[j]+(A+B),(A+B));

        i=(i+1) % t;
        j=(j+1) % c;
    }
}

static unsigned char key[w] = { 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef};

int main(){
    RC5_SETUP(key);

    WORD input[2] = {16, 32};
    WORD output[2] = {0, 0};

    std::cout << "Pre Encrypt:" << std::endl;
    std::cout << std::hex << input[0] << std::dec << std::endl;
    std::cout << std::hex << input[1] << std::dec << std::endl;

    RC5_ENCRYPT(input, output);

    std::cout << "Post Encrypt:" << std::endl;
    std::cout << std::hex << output[0] << std::dec << std::endl;
    std::cout << std::hex << output[1] << std::dec << std::endl;

    RC5_DECRYPT(output, input);

    std::cout << "Post Decrypt:" << std::endl;
    std::cout << std::hex << input[0] << std::dec << std::endl;
    std::cout << std::hex << input[1] << std::dec << std::endl;
}