from fastapi import APIRouter, File, HTTPException, Depends, UploadFile, status, Form
from typing import Annotated
from sqlalchemy.orm import Session
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from app.model import attendance_model
from database import engine, get_db
from utils import manage_token, face_recognition, upload_photos

security = HTTPBearer()

router = APIRouter()

attendance_model.base.metadata.create_all(bind=engine)

chekin_time = "07:30"
chekout_time = "15:30"
attendace_status = None


@router.post("/attendance/")
async def attendace(
    action : Annotated[str, Form(...)],
    date_time: Annotated[str, Form(...)],
    target_face_image: Annotated[UploadFile, File(...)],  
    db:Annotated[Session, Depends(get_db)], 
    credentials: HTTPAuthorizationCredentials = Depends(security)):
  
  token = credentials.credentials
  user_info = manage_token.verify_token(token)
  

  if not user_info:
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid token"
    )

  attendace_status = None
  # current_time = time_stamp.strftime("%H:%M")

  if action =="chek_in" :
    if date_time <= chekin_time:
      attendace_status = "on_time"
    elif date_time > chekin_time:
      attendace_status = "late"
  elif action == "chek_out":
    if date_time < chekout_time:
      attendace_status = "early_leave"


  
  contents = await target_face_image.read()

  succed = face_recognition.findSimilarity(contents, nim= user_info["nim"])
  if succed == False:
    raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Your face is unknown"
    )
  

  file_path = upload_photos.uploadTargetPhotos(target_face_image, contents, user_info["name"], user_info["nim"], action )
  
  db_attendance = attendance_model.Attendance(
    action = action, 
    date_time=date_time, 
    status= attendace_status,
    target_face_image = file_path, 
    user_id = user_info["id"]
  )

  

  try:
    db.add(db_attendance)
    db.commit()
    db.refresh(db_attendance) 
  except HTTPException:
    db.rollback()
    raise HTTPException(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        detail="Failed to register user"
    )

  return {
        "status_code": status.HTTP_201_CREATED,
        "message": "Successfull to attendance",
        "data": {
            "attendance_id": db_attendance.attendace_id,  
            "action": db_attendance.action,
            "time_stamp": db_attendance.date_time,
            "status": db_attendance.status,
            "target_face_image": db_attendance.target_face_image,
            "user_id": db_attendance.user_id

        }
  }