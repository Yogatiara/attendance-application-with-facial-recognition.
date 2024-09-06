from sqlalchemy import Boolean, Column, Integer, String
from database import base

class User(base):
  __tablename__ = "users"

  id = Column(Integer, primary_key=True, index=True)
  username = Column(String(20), unique=True)
  nim = Column(Integer, nullable=False)


class Post(base):
  __tablename__ = 'posts'
  id = Column(Integer, primary_key=True, index=True)
  title = Column(String(20), nullable=False)
  image_url = Column(String(50), nullable=False)
  user_id = Column(Integer)

