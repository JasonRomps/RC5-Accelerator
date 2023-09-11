#include "catch.hpp"
#include "rc5.h"

TEST_CASE("Single Test"){
  unsigned char key[BYTES] = {0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef};
  rc5::word_t S[T] = {0};

  rc5::subkey_init(key, S);
  
  uint32_t data = 0xffff0000;
  uint32_t enc, dec;

  enc = rc5::encrypt(data, S);

  dec = rc5::decrypt(enc, S);

  REQUIRE(dec == data);
}

TEST_CASE("Full Cover Test"){
  unsigned char key[BYTES] = {0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef};
  rc5::word_t S[T] = {0};
  rc5::subkey_init(key, S);

  uint32_t enc, dec;
  for(rc5::block_t i = 0; i <= 0xffff; i++){
    enc = rc5::encrypt(i, S);

    REQUIRE(enc != i);

    dec = rc5::decrypt(enc, S);

    REQUIRE(dec == i);
  }
}