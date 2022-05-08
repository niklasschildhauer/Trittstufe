from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric.x25519 import X25519PrivateKey
from cryptography.hazmat.primitives.kdf.hkdf import HKDF
import base64
from cryptography.hazmat.primitives.asymmetric import x25519
from cryptography.hazmat.primitives.asymmetric.x25519 import X25519PrivateKey, X25519PublicKey
import os
from dotenv import load_dotenv

load_dotenv()

private_key_string = os.getenv('PRIVATE_KEY')

def generate_symmetric_key(public_key_client_string, private_key_string=private_key_string, salt_string = "trittstufe-hdm-stuttgart"):
    # X25519
    public_client_key = X25519PublicKey.from_public_bytes(base64.b64decode(public_key_client_string))
    private_key = X25519PrivateKey.from_private_bytes(base64.b64decode(private_key_string))

    shared_secret = private_key.exchange(public_client_key)

    # HKDF
    symmetric_key = HKDF(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt_string.encode('utf-8'),
        info=b'',
    ).derive(shared_secret)

    print(base64.b64encode(shared_secret))
    print(base64.b64encode(symmetric_key))
    print(symmetric_key)

    return symmetric_key


    