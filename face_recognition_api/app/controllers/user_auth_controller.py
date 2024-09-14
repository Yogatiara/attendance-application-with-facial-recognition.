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

@router.post("/register/", status_code=status.HTTP_201_CREATED)
async def createUser(user_name: Annotated[str, Form(...)], 
    nim: Annotated[int, Form(...)], email: Annotated[str, Form(...)], password : Annotated[str, Form(...)], face_image: Annotated[UploadFile, File(...)],  db:Annotated[Session, Depends(get_db)]):
  
  existing_user = db.query(user_model.User).filter(user_model.User.user_name == user_name).first()

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
  
  existing_email = db.query(user_model.User).filter(user_model.User.email == email).first()
  if existing_email:
      raise HTTPException(
          status_code=status.HTTP_400_BAD_REQUEST,
          detail="Email already registered"
      )
  
  file_path = await upload_photos.uploadSourcePhotos(face_image, user_name, nim)
  
  db_user = user_model.User(
    user_name=user_name, 
    nim=nim, 
		email=email,
    password=hashing_password.hashingPassword(password),
    face_image=file_path
    )

  try:
    db.add(db_user)
    db.commit()
    db.refresh(db_user)

    return {
        "status_code": status.HTTP_201_CREATED,
        "message": "Successfull to register",
        "data": {
            "user_id": db_user.user_id,  
            "username": db_user.user_name,
            "nim": db_user.nim,
            "email": db_user.email,
            "face_image": db_user.face_image

        }
  } 
  except HTTPException:
    db.rollback()
    raise HTTPException(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        detail="Failed to register user"
    )



@router.post("/login/", summary="Login user")
async def login(
    nim: Annotated[int, Form(...)], password : Annotated[str, Form(...)],  db:Annotated[Session, Depends(get_db)]):
  
  find_user = db.query(user_model.User).filter(user_model.User.nim == nim).first()
  if not find_user:
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="user not available"
    )
  
  verfify_password = hashing_password.verifyPassword(password, find_user.password)
  if not verfify_password:
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="wrong password"
    )

  
  access_token = manage_token.create_access_token(find_user.user_id, find_user.nim)

  try:
    db.refresh(find_user)
    return {
        "status_code": status.HTTP_200_OK,
        "message": "Login successfull",
        "access_token": access_token,
        "token_type": "bearer",
        "data": {
            "user_id": find_user.user_id,  
            "username": find_user.user_name,
            "nim": find_user.nim,
        }
  }

  except HTTPException:
      db.rollback()
      raise e

  except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Terjadi kesalahan server: " + str(e)
        )

@router.post("/logout/", summary="Logout user")
async def logout(credentials: HTTPAuthorizationCredentials = Depends(security)):

    token = credentials.credentials
    user_info = manage_token.verify_token(token)

    if not user_info:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )
    
    
    return {
        "status_code": status.HTTP_200_OK,
        "message": "Logout successful"
    }


@router.put("/change-password/", summary="Change password")
async def changePassword(
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
        return {
        "status_code": status.HTTP_200_OK,
        "message": "Password changed successfully"
        }
    except:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update password"
        )

@router.get("/verify-token/", summary="Verify user token") 
async def verify_token(credentials: HTTPAuthorizationCredentials = Depends(security)):

    token = credentials.credentials
    user_info = manage_token.verify_token(token)

    if not user_info:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )

    return {
        "status_code": status.HTTP_200_OK,
        "message": "Token is valid",
        "data": user_info
    }

   
