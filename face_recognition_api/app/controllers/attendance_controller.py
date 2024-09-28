from fastapi import APIRouter, File, HTTPException, Depends, UploadFile, status, Form
from typing import Annotated, Optional
from sqlalchemy.orm import Session
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.responses import FileResponse
from haversine import haversine, Unit



from app.model import attendance_model, user_model
from database import engine, get_db
from utils import manage_token, face_recognition, upload_photos, attendance_management

security = HTTPBearer()

router = APIRouter()

attendance_model.base.metadata.create_all(bind=engine)
user_model.base.metadata.create_all(bind=engine)


chekin_time = "07:30"
chekout_time = "15:30"
attendace_status = None
main_location = (-1.149955, 116.862158)


@router.post("/attendance/", status_code=status.HTTP_201_CREATED)
async def attendace(
    action : Annotated[str, Form(...)],
    date_time: Annotated[str, Form(...)],
    lat: Annotated[float, Form(...)],
    long: Annotated[float, Form(...)],
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
  
  distance = haversine((lat, long), main_location )

  print(round(distance,1))

  roundDistance = round(distance,1)


    
  
  existing_attendances = attendance_management.attendanceChecker(user_info["user_id"], current_date=date_time.split(",")[1] , db=db)

  if existing_attendances >= 2:
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You can only perform attendance twice per day"
        
    )
  
  if (roundDistance  > 0.2):
    raise HTTPException(
      status_code=status.HTTP_403_FORBIDDEN,
      detail= "you are out of range",
    #   detail={
    #     "message": "you are out of range",
    #     "data": {
    #       "range_exception" : True,
    #       "distance": roundDistance
    #   }
    # } 
  )
  
  if existing_attendances == 1:
     action = "chekout"

  contents = await target_face_image.read()
  succed = face_recognition.findSimilarity(contents, nim= user_info["nim"])
  if succed == False:
    raise HTTPException(
      status_code=status.HTTP_400_BAD_REQUEST,
      detail="Your face is unknown"
)
  existing_user = db.query(user_model.User).filter(user_model.User.user_id == user_info["user_id"]).first()

  file_path = upload_photos.uploadTargetPhotos(target_face_image, contents, existing_user.user_name, user_info["nim"], action )
  
  attendace_status = None


  print(action)
  time = date_time.split(",")[0]

  if action =="chekin" :
    if time <= chekin_time:
      attendace_status = attendance_model.StatusAttendance.on_time
    elif time > chekin_time:
      attendace_status = attendance_model.StatusAttendance.late
  elif action == "chekout":
    print("jalan");
    if time < chekout_time:
      attendace_status = attendance_model.StatusAttendance.early_leave
    if time > chekout_time:
      attendace_status = attendance_model.StatusAttendance.over_time


  db_attendance = attendance_model.Attendance(
    action = action, 
    status= attendace_status,
    target_face_image = file_path, 
    date_time = date_time,
    long = long,
    lat = lat,
    distance = roundDistance,
    user_id = user_info["user_id"]
  )

  try:
    db.add(db_attendance)
    db.commit()
    db.refresh(db_attendance) 
  except HTTPException:
    db.rollback()
    raise HTTPException(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        detail="Failed to attendance"
    )

  return {
        "status_code": status.HTTP_201_CREATED,
        "message": "Successfull to attendance",
        "data": {
            "attendance_id": db_attendance.attendace_id,  
            "action": db_attendance.action,
            "user_name": existing_user.user_name,
            "nim": user_info["nim"],
            "status": db_attendance.status,
            "target_face_image": db_attendance.target_face_image,
            "date_time" : db_attendance.date_time,
            "lat" : db_attendance.lat,
            "log" : db_attendance.long,
            "distance" : db_attendance.distance,
            "user_id": db_attendance.user_id

        }
  }


@router.get("/get-attendance", summary="Get attendance by date and action") 
async def verify_token(
  db: Annotated[Session, Depends(get_db)],
    credentials: HTTPAuthorizationCredentials = Depends(security),
    date: Optional[str] = None,
    action: Optional[str] = None
):

  token = credentials.credentials
  user_info = manage_token.verify_token(token)


  if not user_info:
      raise HTTPException(
          status_code=status.HTTP_401_UNAUTHORIZED,
          detail="Invalid token"
      )

  attendance_records = attendance_management.attendanceFilterByDateAndAction(user_id=user_info["user_id"], date=date, action=action, db=db)
  
  return {
        "status_code": status.HTTP_200_OK,
        "message": "Attendance records retrieved successfully",
        "data": [
            {
                "attendance_id": record.attendace_id,
                "date_time": record.date_time,
                "action": record.action,
                "status": record.status,
            }
            for record in attendance_records
        ]
    }

@router.get("/get-all-attendance/", summary="Get all attendance data") 
async def verify_token(
  db: Annotated[Session, Depends(get_db)],
    credentials: HTTPAuthorizationCredentials = Depends(security),
    date: Optional[str] = None,
    action: Optional[str] = None
):

  token = credentials.credentials
  user_info = manage_token.verify_token(token)


  if not user_info:
      raise HTTPException(
          status_code=status.HTTP_401_UNAUTHORIZED,
          detail="Invalid token"
      )

  attendance_records = attendance_management.attendanceFilterByDateAndAction(user_id=user_info["user_id"], date=date, action=action, db=db)
  
  return {
        "status_code": status.HTTP_200_OK,
        "message": "Attendance records retrieved successfully",
        "data": [
            {
                "attendance_id": record.attendace_id,
                "date_time": record.date_time,
                "action": record.action,
                "status": record.status,
            }
            for record in attendance_records
        ]
    }
