from dotenv import load_dotenv
import os
import jwt

load_dotenv()

jwt_key = os.getenv('JWT_KEY')
valid_account_names = ["Ansgar", "Niklas", "Test"]

def is_token_valid(token, key=jwt_key):
    print(key)
    try:
        decoded = jwt.decode(token, key, algorithms="HS256")
        print(decoded)
        if decoded["accountName"] in valid_account_names: return True
        return False
    except jwt.InvalidSignatureError:
        return False

def generate_token(user, key=jwt_key):
    print(jwt.encode({"accountName": user}, key, algorithm="HS256"))
