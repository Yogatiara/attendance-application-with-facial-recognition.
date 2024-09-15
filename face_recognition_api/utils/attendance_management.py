from datetime import datetime
import pytz
from tzlocal import get_localzone
from sqlalchemy.orm import Session
from app.model import attendance_model

def attendanceChecker(user_id: int, current_date:str, db: Session):
    # local_tz = get_localzone()
    # local_time = datetime.now(local_tz)
    # current_date = local_time.strftime("%d %b %Y")

    existing_attendances = db.query(attendance_model.Attendance).filter(
        attendance_model.Attendance.user_id == user_id,
        attendance_model.Attendance.date_time.like(f"%,{current_date}")
    ).count()

    return existing_attendances;

def attendanceFilterByDateAndAction(user_id: int, date: str,  action: str, db: Session):

    query = db.query(attendance_model.Attendance).filter(
        attendance_model.Attendance.user_id == user_id
    )

    if date:
        query = query.filter(attendance_model.Attendance.date_time.like(f"%{date}%"))

    if action:
        query = query.filter(attendance_model.Attendance.action.like(f"{action}%"))

    attendance_records = query.all()
    return attendance_records

