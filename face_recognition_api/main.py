from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse
from database import engine

from app.controllers.user_controller import router as user_router
from app.model import attendance_model

attendance_model.base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(user_router, prefix="/users")

@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "status_code": exc.status_code,
            "detail": exc.detail
        }
    )
