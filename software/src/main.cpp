#include <iostream>
#include <iomanip>

#include "rc5.h"

#define RED "\x1b[1;31m"
#define CLEAR "\033[0m"

unsigned char key[BYTES] = {0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef};
rc5::word_t S[T] = {0};

#define DATA 0xecebeceb

int main(int argc, char *argv[]){
    std::cout << "Data In: " << std::hex << DATA << std::dec << std::endl;
    
    rc5::subkey_init(key, S);
    rc5::block_t enc, dec;

    enc = rc5::encrypt(DATA, S);
    
    std::cout << "Encrypted Data: " << std::hex << enc << std::dec << std::endl;

    dec = rc5::decrypt(enc, S);

    std::cout << "Data Out: " << std::hex << dec << std::dec << std::endl;
}

