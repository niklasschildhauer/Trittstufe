from base64 import b64decode
from Crypto.Cipher import ChaCha20_Poly1305
from X25519 import generate_symmetric_key 

def encrypt_cipher_text(cipher_stirng, public_key):
    symmetric_key = generate_symmetric_key(public_key_client_string=public_key)
    cipher_data = b64decode(cipher_stirng)

    combinedNonce = cipher_data[:12]
    combinedTag = cipher_data[:-16]
    combinedCipher = cipher_data[12:-16]
    decrypted = ChaCha20_Poly1305.new(key=symmetric_key, nonce=combinedNonce).decrypt(combinedCipher).decode()

    print(decrypted)
    return decrypted

encrypt_cipher_text(cipher_stirng="ZNIvFXjd0muBVgGWCDp/kg13FpPPO05NF/XPKcmwRmLlKZhbH3JF9AdHw0g=", public_key="zcGAPyM0PksNZ3Y+4zz+QKAtUbEQzWf89pU1MHL923w=")

# key = b64decode("OyDnFiZ9/KX5ltBcTo0cHXmzMD5gxxJwzG776WQeowQ=")
# combined = b64decode("Abd8r73b64IPysRgqsMehYzVz/aiL2IPlql2XFphH8vx1Q+MNLGJAvTL/rg=")

# text = "Das ist ein Test"

# combinedNonce = combined[:12]
# combinedTag = combined[:-16]
# combinedCipher = combined[12:-16]
# decrypted = ChaCha20_Poly1305.new(key=key, nonce=combinedNonce).decrypt(combinedCipher).decode()

# if decrypted == text:
#     print("OK!")
#     print(decrypted)