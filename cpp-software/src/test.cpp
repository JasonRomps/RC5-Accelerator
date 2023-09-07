#include "catch.hpp"

#include "rc5.h"


TEST_CASE("TEST"){
  unsigned char key[16] = {0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef};
  unsigned short subkeys[SUBKEY_LEN];

  generate_subkeys(subkeys, key);

  int data = 1994242;
  int enc, dec;

  enc = encrypt(data, subkeys);

  dec = decrypt(enc, subkeys);

  REQUIRE(dec == data);
}