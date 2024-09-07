from fastapi import FastAPI
from database import engine

from app.controllers.user_controller import router as user_router
from app.model import attendance_model

attendance_model.base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(user_router, prefix="/users")
