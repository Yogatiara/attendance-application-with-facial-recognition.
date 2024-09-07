from fastapi import APIRouter, HTTPException, Depends, status, Form
from typing import Annotated
from sqlalchemy.orm import Session

from app.model import user_model
from database import engine
from utils import hashing_password
from database import get_db

router = APIRouter()

user_model.base.metadata.create_all(bind=engine)

@router.post("/register/")
async def create_user(username: Annotated[str, Form(...)], 
    nim: Annotated[int, Form(...)], password : Annotated[str, Form(...)],  db:Annotated[Session, Depends(get_db)]):
  
  db_user = user_model.User(username=username, nim=nim, password=hashing_password.hashingPassword(password),  face_image=None 
)
  existing_user = db.query(user_model.User).filter(user_model.User.username == username).first()

  if existing_user:
    raise HTTPException(
        status_code=status.HTTP_400_BAD_REQUEST,
        detail="Username already registered"
    )
  
  existing_nim = db.query(user_model.User).filter(user_model.User.nim == nim).first()
  if existing_nim:
      raise HTTPException(
          status_code=status.HTTP_400_BAD_REQUEST,
          detail="NIM already registered"
      )

  try:
      db.add(db_user)
      db.commit()
      db.refresh(db_user) 
  except HTTPException:
      db.rollback()
      raise HTTPException(
          status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
          detail="Failed to register user"
      )

  return {
        "status_code": status.HTTP_201_CREATED,
        "message": "Successfull to register",
        "data": {
            "id": db_user.user_id,  
            "username": db_user.username,
            "nim": db_user.nim,
            "password": db_user.password

        }
  }