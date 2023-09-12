#include "catch.hpp"
#include "rc5.h"

#include <stdio.h>
#include <iomanip>

unsigned char key[BYTES] = {0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef};

TEST_CASE("Single Test"){
  rc5::word_t S[T] = {0};

  rc5::subkey_init(key, S);
  
  uint32_t data = 0xffff0000;
  uint32_t enc, dec;

  enc = rc5::encrypt(data, S);

  dec = rc5::decrypt(enc, S);

  REQUIRE(dec == data);

  printf("Simple Test Complete\n");
}

TEST_CASE("Full Cover Test"){
  rc5::word_t S[T] = {0};
  rc5::subkey_init(key, S);

  uint32_t enc, dec;
  for(rc5::block_t i = 0; i <= 0xfffffff; i += 13){
    printf("\rFull Test Completion (%.2f/100)", ((float)(i)/0xfffffff)*100);
    enc = rc5::encrypt(i, S);

    REQUIRE(enc != i);

    dec = rc5::decrypt(enc, S);

    REQUIRE(dec == i);
  }

  printf("\rFull Test Completion (100.00/100)\n");
}