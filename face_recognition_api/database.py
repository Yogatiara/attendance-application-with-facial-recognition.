from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

URL_DATABASE = URL_DATABASE = "mysql+pymysql://root@localhost:3306/face_recognition"


engine = create_engine(URL_DATABASE)

SessionLocal = sessionmaker(bind=engine)

base = declarative_base()


def get_db():
  db = SessionLocal()
  try:
    yield db
  finally:
    db.close()