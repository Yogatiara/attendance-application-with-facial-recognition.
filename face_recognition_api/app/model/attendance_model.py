from sqlalchemy import Boolean, Column, Integer, String, Enum, ForeignKey
from database import base
from sqlalchemy.orm import relationship
import enum

class StatusAttendance(enum.Enum):
    on_time = "on time"
    late = "late"
    early_leave = "early leave"

class Attendance(base):
  __tablename__ = 'attendance'
  attendace_id = Column(Integer, primary_key=True, index=True)
  image_url = Column(String(50), nullable=False)
  time_stamp = Column(String(20), nullable=False)
  status = Column(Enum(StatusAttendance), nullable=False)
  user_id = Column(Integer, ForeignKey('user.user_id'), nullable=False)

  user = relationship("User", back_populates="attendance")

