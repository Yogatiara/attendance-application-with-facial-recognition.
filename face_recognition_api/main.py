from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse

from app.controllers.user_auth_controller import router as user_auth_router
from app.controllers.attendance_controller import router as attendance_router
from app.controllers.user_controller import router as user_router

app = FastAPI()
prefix = "/user"

app.include_router(user_auth_router, prefix=prefix, tags=["Auth"])
app.include_router(user_router, prefix= prefix, tags=["User accsess"])
app.include_router(attendance_router, prefix=prefix, tags=["Attendance"])

@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "status_code": exc.status_code,
            "detail": exc.detail
        }
    )
