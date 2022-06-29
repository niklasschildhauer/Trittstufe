from dotenv import load_dotenv
import os
import jwt

load_dotenv()

jwt_key = os.getenv('JWT_KEY') # shared jwt key
valid_account_names = ["Ansgar", "Niklas", "Test"] # hardcoded valid user names

# function to validate the jwt token
def is_token_valid(token, key=jwt_key):
    print(key)
    try:
        decoded = jwt.decode(token, key, algorithms="HS256")
        print(decoded)
        # if the decoded accountName is in valid_account_names return true. Otherwise false
        if decoded["accountName"] in valid_account_names: return True
        return False
    except jwt.InvalidSignatureError:
        return False

# function to generate a new jwt key
def generate_token(user, key=jwt_key):
    print(jwt.encode({"accountName": user}, key, algorithm="HS256"))
