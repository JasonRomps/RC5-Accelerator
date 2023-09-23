#include "rc5.h"

rc5::word_t rc5::rotl(rc5::word_t x, rc5::word_t y){
    rc5::word_t n = y % W;
    return (((x)<<(n)) | ((x)>>(W-n)));
}

rc5::word_t rc5::rotr(rc5::word_t x, rc5::word_t y){
    rc5::word_t n = y % W;
    return (((x)>>(n)) | ((x)<<(W-n)));
}

rc5::block_t rc5::encrypt(rc5::block_t data, rc5::word_t S[T]){
    rc5::word_t A = (rc5::word_t)(data & LOW_MASK);
    rc5::word_t B = (rc5::word_t)((data >> W) & LOW_MASK);
    rc5::word_t i;

    A += S[0];
    B += S[1];

    for (i=1; i<=R; i++){
        A = rc5::rotl(A^B, B) + S[2*i];
        B = rc5::rotl(B^A, A) + S[2*i+1];
    }

    return ((rc5::block_t)(A & LOW_MASK)) | (((rc5::block_t)(B & LOW_MASK)) << W);
}

rc5::block_t rc5::decrypt(rc5::block_t data, rc5::word_t S[T]){
    rc5::word_t A = (rc5::word_t)(data & LOW_MASK);
    rc5::word_t B = (rc5::word_t)((data >> W) & LOW_MASK);
    rc5::word_t i;

    for (i=R; i>0; i--){
        B = rc5::rotr(B-S[2*i+1], A) ^ A;
        A = rc5::rotr(A-S[2*i], B) ^ B;
    }

    B -= S[1];
    A -= S[0];

    return ((rc5::block_t)(A & LOW_MASK)) | (((rc5::block_t)(B & LOW_MASK)) << W);
}

void rc5::subkey_init(rc5::key_t K, rc5::word_t S[T]){  
    rc5::word_t j, k, u=W/8, A, B, L[C];
    int i;

    /* Initialize L, then S, then mix key into S */
    L[C-1] = 0;
    for (i=BYTES-1; i!=-1; i--){
        L[i/u] = (L[i/u] << 8) + K[i];
    }

    for (S[0]=P,i=1; i<T; i++){
        S[i] = S[i-1] + Q;
    }

    A = B = j = k = 0;
    for (i = 0; k < 3*T; k++){
        A = S[i] = rc5::rotl(S[i]+(A+B),3); // A <= A_new; s[i] <= A_new;
        B = L[j] = rc5::rotl(L[j]+(A+B),(A+B)); // B <= B_new; L[j] <= B_new; ***NOTE: USE A_new***

        i=(i+1) % T; // i <= i_new;
        j=(j+1) % C; // i <= i_new;
    }
}