#include "catch.hpp"
#include "rc5.h"

#include <iostream>


TEST_CASE("TEST"){
  unsigned char key[16] = {0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef};
  unsigned short subkeys[SUBKEY_LEN] = {0};

  generate_subkeys(subkeys, key);

  uint32_t data = 225;
  uint32_t enc, dec;

  enc = encrypt(data, subkeys);

  dec = decrypt(enc, subkeys);

  REQUIRE(dec == data);
}