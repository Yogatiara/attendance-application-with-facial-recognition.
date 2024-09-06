from fastapi import FastAPI, HTTPException, Depends, status, Form
from pydantic import BaseModel
from typing import Annotated

import models
from database import engine, SessionLocal
from sqlalchemy.orm import Session

app = FastAPI()
models.base.metadata.create_all(bind=engine)

class PostBase(BaseModel):
  title: str = Form(...)
  image_url: str = Form(...)


def get_db():
  db = SessionLocal()
  try:
    yield db
  finally:
    db.close()

db_dependency = Annotated[Session, Depends(get_db)]


@app.post("/register/", status_code=status.HTTP_201_CREATED)
async def create_user(username: Annotated[str, Form(...)], 
    nim: Annotated[int, Form(...)],  db:db_dependency):
  db_user = models.User(username=username, nim=nim)
  db.add(db_user)
  db.commit()


  return {
        "message": "Successfull to register",
        "user": {
            "id": db_user.id,  
            "username": db_user.username,
            "nim": db_user.nim
        }
  }
