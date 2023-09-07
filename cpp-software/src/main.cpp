#include <iostream>

#include "rc5.h"

void print_char_arr(unsigned char * arr, int n){
    std::cout << "[";
    for(int i = 0; i < n; i++){
        std::cout << (int)arr[i] << (i == n-1 ? "":", ");
    }
    std::cout << "]" << std::endl;
}

void print_short_arr(unsigned short * arr, int n){
    std::cout << "[";
    for(int i = 0; i < n; i++){
        std::cout << (int)arr[i] << (i == n-1 ? "":", ");
    }
    std::cout << "]" << std::endl;
}


int main(){

    unsigned char key[16] = {0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef};
    unsigned short L[8] = {0};
    unsigned short S[26] = {0};

    int W = 16; // :: Word Size = Input Block Size / 8
    int b = 16; // :: Key Length in Bytes
    int R = 12;
    int T = 2 * (R + 1);
    int C = 8;

    for(int i = KEY_LEN-1; i > 0; i--){
        L[i/CONST_U] = (L[CONST_U/i] << 8) + key[i];
    }

    S[0] = CONST_P;

    for(int i = 1; i < T; i++){
        S[i] = S[i-1] + CONST_Q;
    }


    int i, j = 0;
    unsigned short A, B = 0;

    int count = T;
    while(count > 0){
        A = S[i] = (S[i] + A + B) << 3;
        B = L[j] = (L[j] + A + B) << (A+B);
        i = (i + 1) % T;
        j = (j + 1) % C;
        count --;
    }

    unsigned short S_TEST[26];
    generate_subkeys(S_TEST, key);

    print_short_arr(S, 26);
    print_short_arr(S_TEST, 26);

    // print_short_arr(S, 26);
    
    uint32_t DATA = 0xcadecade;
    uint16_t DATA_A = 0x0000ffff & DATA;
    uint16_t DATA_B = 0x0000ffff & (DATA >> 8);

    DATA_A = DATA_A + S[0];
    DATA_A = DATA_A + S[0];

    for(int i = 0; i < R; i++){
        A = ((A ^ B) << B) + S[2 * i];
        B = ((B ^ A) << A) + S[(2 * i) + 1];
    }

    return 0;
}



// # -------- CONST DECLARATIONS --------
// W = 16 # Word Size
// Key = b'\xde\xad\xbe\xef\xde\xad\xbe\xef\xde\xad\xbe\xef\xde\xad\xbe\xef'
// B = len(Key)
// U = W // 8
// C = B // U
// L = [0] * C
// R = 12
// T=2*(R+1)

// P = b'\xb7\xe1'
// Q = b'\x9e\x37'

// # -------- KEY EXPANSION --------
// for i in range(B-1, 0, -1):
//     L[i//U] = (L[U//i] << 8) + Key[i]

// print(f"Key Expansion Array L: {L}")

// S = [0] * T
// S[0] = P


// # for i = 1 to 2(r+1)-1
// #     S[i] = S[i-1] + Q)
// for i in range(1, T-1):
//     S[i] = S[i-1] + Q
    
// print(f"Subkey Array S: {S}")

// i = j = 0
// A = B = 0

// S = [int(x, 16) for x in S]

// reps = int(max(T, C) * 3)

// while reps > 0:
//     A = S[i] = (S[i] + A + B) << 3
//     B = L[j] = (L[j] + A + B) << (A+B)
//     i = (i+1) % T
//     j = (j+1) % C
//     reps -= 1

