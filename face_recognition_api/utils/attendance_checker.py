from datetime import datetime
import pytz
from tzlocal import get_localzone
from sqlalchemy.orm import Session
from app.model import attendance_model

def attendanceChecker(user_id: int, db: Session):
    local_tz = get_localzone()
    local_time = datetime.now(local_tz)
    current_date = local_time.strftime("%d %b %Y")

    existing_attendances = db.query(attendance_model.Attendance).filter(
        attendance_model.Attendance.user_id == user_id,
        attendance_model.Attendance.date_time.like(f"%,{current_date}")
    ).count()

    return existing_attendances;

