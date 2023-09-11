#pragma once

#define W        16             /* word size in bits                 */
#define R        12             /* number of rounds                  */
#define BYTES    16             /* number of bytes in key            */
#define C        ((8*BYTES)/W)  /* number  words in key = ceil(8*b/w)*/
#define T        (2*(R+1))      /* size of table S = 2*(r+1) words   */
#define LOW_MASK 0x0000ffff
#define HIGH_MASK 0xffff0000

#define P 0xb7e1
#define Q 0x9e37

namespace rc5{

    typedef unsigned short word_t;
    typedef unsigned int block_t;
    typedef unsigned char* key_t;

    rc5::word_t rotr(rc5::word_t x, rc5::word_t y);
    rc5::word_t rotl(rc5::word_t x, rc5::word_t y);

    rc5::block_t encrypt(rc5::block_t data, rc5::word_t S[T]);
    rc5::block_t decrypt(rc5::block_t data, rc5::word_t S[T]);
    void subkey_init(rc5::key_t K, rc5::word_t S[T]);
}