from base64 import b64decode
from Crypto.Cipher import ChaCha20_Poly1305
from Cryptography.X25519 import generate_symmetric_key 

def encrypt_cipher_text(cipher_stirng, public_key):
    symmetric_key = generate_symmetric_key(public_key_client_string=public_key)
    cipher_data = b64decode(cipher_stirng)

    combinedNonce = cipher_data[:12]
    combinedTag = cipher_data[:-16]
    combinedCipher = cipher_data[12:-16]
    decrypted = ChaCha20_Poly1305.new(key=symmetric_key, nonce=combinedNonce).decrypt(combinedCipher).decode()

    print(decrypted)
    return decrypted
