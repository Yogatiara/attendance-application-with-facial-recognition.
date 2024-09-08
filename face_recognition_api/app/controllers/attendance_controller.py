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
    time_stamp: Annotated[str, Form(...)],
    face_image: Annotated[UploadFile, File(...)],  
    db:Annotated[Session, Depends(get_db)], 
    credentials: HTTPAuthorizationCredentials = Depends(security)):
  
  token = credentials.credentials
  user_info = manage_token.verify_token(token)
  

  if not user_info:
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid token"
    )
  
  # if action not in [e.value for e in attendance_model.AttendanceAction]:
  #   raise HTTPException(
  #       status_code=status.HTTP_400_BAD_REQUEST,
  #       detail="Invalid action"
  #   )
  
  attendace_status = None


  
  if action =="chek_in" :
    if time_stamp <= chekin_time:
      attendace_status = "on_time"
    elif time_stamp > chekin_time:
      attendace_status = "late"
  elif action == "chek_out":
    if time_stamp < chekout_time:
      attendace_status = "early_leave"

  # if attendace_status not in [e.value for e in attendance_model.StatusAttendance]:
  #   raise HTTPException(
  #       status_code=status.HTTP_400_BAD_REQUEST,
  #       detail="Invalid status"
  #   )
  

  
  contents = await face_image.read()

  succed = face_recognition.findSimilarity(contents, nim= user_info["nim"])
  if succed == False:
    raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Your face is unknown"
    )
  

  file_path = upload_photos.uploadTargetPhotos(face_image, contents, user_info["name"], user_info["nim"], action )
  
  db_recognition = attendance_model.Attendance(
    action = action, 
    time_stamp=time_stamp, 
    status= attendace_status, 
    target_face_image = file_path, 
    user_id = user_info["id"]
  )

  

  try:
    db.add(db_recognition)
    db.commit()
    db.refresh(db_recognition) 
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
            "id": db_recognition.attendace_id,  
            "action": db_recognition.action,
            "time_stamp": db_recognition.time_stamp,
            "status": db_recognition.status,
            "target_face_image": db_recognition.target_face_image,
            "user_id": db_recognition.user_id

        }
  }