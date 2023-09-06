import pytest

from rc5 import RC5

BLOCK_SIZE = 16
NUM_ROUNDS = 15
KEY = b'\xdeadbeefdeadbeefdeadbeefdeadbeef'

@pytest.fixture
def enc_module():
    return RC5(BLOCK_SIZE, NUM_ROUNDS, KEY, True)


def test_enc_and_dec(enc_module: RC5):
    
    data_in = b'\x00\x01\x02\03'

    data_enc = enc_module.encryptBlock(data_in)

    data_dec = enc_module.decryptBlock(data_enc)

    assert data_dec == data_in