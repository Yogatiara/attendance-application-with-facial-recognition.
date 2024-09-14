from sqlalchemy import Boolean, Column, Integer, String, Enum, ForeignKey
from database import base
from sqlalchemy.orm import relationship
import enum

class StatusAttendance(enum.Enum):
    on_time = "on time"
    late = "late"
    early_leave = "early leave"

class AttendanceAction(enum.Enum):
    chekin = "chekin"
    chekout = "chekout"

class Attendance(base):
  __tablename__ = 'attendance'
  attendace_id = Column(Integer, primary_key=True, index=True)
  action = Column(Enum(AttendanceAction), nullable= False)
  status = Column(Enum(StatusAttendance), nullable=False)
  target_face_image =  Column(String(255), nullable=True)
#   time = Column(String(20), nullable=False)
#   date = Column(String(20), nullable=False)
  date_time = Column(String(20), nullable=False);
  user_id = Column(Integer, ForeignKey('user.user_id'),
   nullable=False)

  user = relationship("User", back_populates="attendance")

