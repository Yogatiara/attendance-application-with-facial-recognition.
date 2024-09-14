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

@router.get("/get-user/", summary="Get user by token") 
async def verify_token(db:Annotated[Session, Depends(get_db)],  credentials: HTTPAuthorizationCredentials = Depends(security)):

  token = credentials.credentials
  user_info = manage_token.verify_token(token)
  find_user = db.query(user_model.User).filter(user_model.User.nim ==  user_info["nim"]).first()

  if not user_info:
      raise HTTPException(
          status_code=status.HTTP_401_UNAUTHORIZED,
          detail="Invalid token"
      )

  return {
      "status_code": status.HTTP_200_OK,
      "message": "Get user is success",
      "data": {
          "user_id": user_info["user_id"],  
          "username": find_user.user_name,
          "nim": user_info["nim"],
      }
  }

   
