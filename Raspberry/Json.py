import json
import Cryptography.ChaCha20 as ChaCha20


# json_data = '{\"publicKey\":\"pD\\/HSz2ybG431+0OyEXAk2f7SeBkAVu+XRodNn9lMnU=\",\"payload\":\"1bLlmSg5aPbf22tSFydZZD9UoXaI6d2NEaova6iYhLEVLhZM4HBFsvnTOtStJUfG0JAEwGno9eJLz1YVN0fgx8L5\"}'

# json = json.loads(json_data)

# public_key = json['publicKey']
# payload = json['payload']

# print("test")
# print(public_key)
# print(payload)
# print("test")

# message = ChaCha20.encrypt_cipher_text(cipher_stirng=payload, public_key=public_key)

# print(message)


data = [{"side":"left", "position": "open"}, {"side":"right", "position": "close"}]
print(json.dumps(data))