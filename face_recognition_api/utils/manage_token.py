import os
from datetime import timedelta, datetime, timezone
from pathlib import Path
from fastapi import HTTPException, status
from jose import JWTError, jwt
from dotenv import load_dotenv

env_path = Path('./') / '.env'
load_dotenv(dotenv_path=env_path)

SECRET_KEY = os.getenv('SECRET_KEY')
ALGORITHM = os.getenv('ALGORITHM')

ACCESS_TOKEN_EXPIRE = 30

def create_access_token(user_id: int, userame: str, nim :int):
  encode = {"id": user_id, "name": userame, "nim": nim}
  access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE)

  expires = datetime.now(timezone.utc) + access_token_expires
  encode.update({"exp": expires})

  return jwt.encode(encode, SECRET_KEY, algorithm=ALGORITHM)

def verify_token(token: str):
  credentials_exception = HTTPException(
      status_code=status.HTTP_401_UNAUTHORIZED,
      detail="Could not validate credentials",
      headers={"WWW-Authenticate": "Bearer"},
  )
  try:
      payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
     
  except JWTError:
      raise credentials_exception
  

  return payload