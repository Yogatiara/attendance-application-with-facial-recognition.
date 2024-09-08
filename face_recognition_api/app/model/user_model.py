from sqlalchemy import Boolean, Column, Integer, String
from sqlalchemy.orm import relationship

from database import base

class User(base):
  __tablename__ = "user"

  user_id = Column(Integer, primary_key=True, index=True)
  user_name = Column(String(20),nullable=True, unique=True)
  nim = Column(Integer, nullable=False, unique=True)
  password = Column(String(255), nullable=False)
  face_image = Column(String(50), nullable=True)

  attendance = relationship("Attendance", back_populates="user")

