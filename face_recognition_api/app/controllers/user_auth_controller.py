from fastapi import APIRouter, File, HTTPException, Depends, UploadFile, status, Form
from typing import Annotated
from sqlalchemy.orm import Session
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from app.model import user_model
from database import engine
from utils import hashing_password, upload_photos, manage_token


from database import get_db
security = HTTPBearer()

router = APIRouter()

user_model.base.metadata.create_all(bind=engine)

@router.post("/register/")
async def create_user(username: Annotated[str, Form(...)], 
    nim: Annotated[int, Form(...)], password : Annotated[str, Form(...)], face_image: Annotated[UploadFile, File(...)],  db:Annotated[Session, Depends(get_db)]):
  
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
  file_path = await upload_photos.uploadPhotos(face_image, username, nim)
  
  db_user = user_model.User(username=username, nim=nim, password=hashing_password.hashingPassword(password),  face_image=file_path)

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
            "password": db_user.password,
            "face_image": db_user.face_image

        }
  }

@router.post("/login/", summary="Login user")
async def login(
    nim: Annotated[int, Form(...)], password : Annotated[str, Form(...)],  db:Annotated[Session, Depends(get_db)]):
  
  find_user = db.query(user_model.User).filter(user_model.User.nim == nim).first()
  if not find_user:
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="User is not exist"
    )
  
  verfify_password = hashing_password.verifyPassword(password, find_user.password)
  if not verfify_password:
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Incorrect password"
    )

  
  access_token = manage_token.create_access_token(find_user.user_id, find_user.username, find_user.nim)

  try:
      db.refresh(find_user) 
  except HTTPException:
      db.rollback()
      raise HTTPException(
          status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
          detail="Failed to register user"
      )

  return {
        "status_code": status.HTTP_200_OK,
        "message": "Login successfull",
        "access_token": access_token,
        "token_type": "bearer",
        "data": {
            "id": find_user.user_id,  
            "username": find_user.username,
            "nim": find_user.nim,
        }
  }

@router.put("/change-password/", summary="Change password")
async def change_password(
    old_password: Annotated[str, Form(...)],
    new_password: Annotated[str, Form(...)],
    db: Annotated[Session, Depends(get_db)],
    credentials: HTTPAuthorizationCredentials = Depends(security),

):
    token = credentials.credentials
    user_info = manage_token.verify_token(token)

    if not user_info:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )

    find_user = db.query(user_model.User).filter(user_model.User.user_id == user_info['id']).first()

    if not find_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )

    if not hashing_password.verifyPassword(old_password, find_user.password):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Old password is incorrect"
        )

    hashed_new_password = hashing_password.hashingPassword(new_password)

    find_user.password = hashed_new_password
    try:
        db.commit()
        db.refresh(find_user)
    except:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update password"
        )

    return {
        "status_code": status.HTTP_200_OK,
        "message": "Password changed successfully"
    }
