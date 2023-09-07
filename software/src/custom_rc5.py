

def bytes_as_int(b: bytes):
    pass

# -------- CONST DECLARATIONS --------
W = 16 # Word Size
Key = b'\xde\xad\xbe\xef\xde\xad\xbe\xef\xde\xad\xbe\xef\xde\xad\xbe\xef'
B = len(Key)
U = W // 8
C = B // U
L = [0] * C
R = 12
T=2*(R+1)

P = b'\xb7\xe1'
Q = b'\x9e\x37'

print(C)
exit(0)

# -------- KEY EXPANSION --------
for i in range(B-1, 0, -1):
    L[i//U] = (L[U//i] << 8) + Key[i]

print(f"Key Expansion Array L: {L}")

S = [0] * T
S[0] = P


# for i = 1 to 2(r+1)-1
#     S[i] = S[i-1] + Q)
for i in range(1, T-1):
    S[i] = S[i-1] + Q
    
print(f"Subkey Array S: {S}")

i = j = 0
A = B = 0

S = [int(x, 16) for x in S]

reps = int(max(T, C) * 3)

while reps > 0:
    A = S[i] = (S[i] + A + B) << 3
    B = L[j] = (L[j] + A + B) << (A+B)
    i = (i+1) % T
    j = (j+1) % C
    reps -= 1

