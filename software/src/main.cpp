#include <iostream>
#include <iomanip>
#include <string>
#include <vector>

#include "rc5.h"

#define RED "\x1b[1;31m"
#define CLEAR "\033[0m"

unsigned char key[BYTES] = {0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef};
rc5::word_t S[T] = {0};

#define DATA 0xecebeceb

std::vector<char> HexToBytes(const std::string& hex) {
  std::vector<char> bytes;

  for (unsigned int i = 0; i < hex.length(); i += 2) {
    std::string byteString = hex.substr(i, 2);
    char byte = (char) strtol(byteString.c_str(), NULL, 16);
    bytes.push_back(byte);
  }

  return bytes;
}

int main(int argc, char *argv[]){

    if(argc == 3 && std::string(argv[1]) == "subkey_show"){
        std::string key_in(argv[2]);

        if(key_in.size() != BYTES * 2) {
            std::cout << "Invalid Key Size!" << std::endl;
            exit(-1);
        }

        std::vector<char> bts = HexToBytes(key_in);

        int i = 0;
        for(auto &b : bts){
            key[i] = (unsigned char)b;
            i++;
        }

        rc5::subkey_init(key, S);

        for(uint32_t i = 0; i < T; i++){
            std::cout << S[i] << " ";
        }
        std::cout << std::endl;

        exit(0);
    }

    std::cout << "Data In: " << std::hex << DATA << std::dec << std::endl;
    
    rc5::subkey_init(key, S);

    rc5::block_t enc, dec;

    enc = rc5::encrypt(DATA, S);
    
    std::cout << "Encrypted Data: " << std::hex << enc << std::dec << std::endl;

    dec = rc5::decrypt(enc, S);

    std::cout << "Data Out: " << std::hex << dec << std::dec << std::endl;
}

