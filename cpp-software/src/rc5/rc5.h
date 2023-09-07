#pragma once


#define CONST_P 0xb7e1  //
#define CONST_Q 0x9e37  // Magic Constants Defined by RC5 Algo

#define WORD_SIZE 16    // Number of bits in rc5 'word'
#define KEY_LEN 16      // Number of bytes in rc5 encryption key
#define CONST_U (WORD_SIZE / 8)

#define CONST_R 255
#define CONST_T (2 * (CONST_R + 1))
#define CONST_C 8

#define SUBKEY_LEN 26
#define subkey_t unsigned short

void generate_subkeys(subkey_t * S, unsigned char * key);

unsigned int encrypt(unsigned int data, subkey_t* subkey);

unsigned int decrypt(unsigned int data, subkey_t* subkey);