import cv2
import insightface
import numpy as np
import os

from insightface.app import FaceAnalysis
from typing import Union
from fastapi import FastAPI
from fastapi import FastAPI, File, UploadFile, Form, HTTPException, status, Depends, Form
from io import BytesIO
from PIL import Image
from fastapi.responses import JSONResponse
from typing import Optional


app = FastAPI()

app_insight = insightface.app.FaceAnalysis(name="buffalo_l")
app_insight.prepare(ctx_id=0, det_size=(640, 640))

recognition = insightface.model_zoo.get_model('./model/w600k_r50.onnx', download=False, download_zip=False)
recognition.prepare(ctx_id=0)

IMAGEDIR = "./photos"



fake_users_db = {
    1: {"id": 1, "username": "yoga","email": "user1@example.com", "password": "password123"},
    2: {"id": 2, "username": "user2", "email": "user2@example.com", "password": "password456"},
}

def authenticate_user(username: str, password: str):
    for user in fake_users_db.values():
        if user["username"] == username and user["password"] == password:
            return user
    return None

def get_user_by_id(user_id: int):
    return fake_users_db.get(user_id)

@app.post("/login/")
async def login(username: str = Form(...), password: str = Form(...)):
    user = authenticate_user(username, password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
        )
    return {"id": user["id"], "username": user["username"]}

@app.get("/users/me")
async def read_users_me(user_id: Optional[int] = None):
    if user_id is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="No user ID provided",
        )
    
    user = get_user_by_id(user_id)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )
    
    return user



def process_image(faces: list, img_array: list):

    face_areas = [(face.bbox[2] - face.bbox[0]) * (face.bbox[3] - face.bbox[1]) for face in faces]
    largest_face_index = face_areas.index(max(face_areas))
    
    face = faces[largest_face_index]
    embed = recognition.get(img_array, face)
    print(embed)

    return embed

def process_image_from_file(file_path: str):
    img_array = cv2.imread(file_path)
    img_array = cv2.cvtColor(img_array, cv2.COLOR_BGR2RGB)
    
    faces = app_insight.get(img_array)

    face_areas = [(face.bbox[2] - face.bbox[0]) * (face.bbox[3] - face.bbox[1]) for face in faces]
    largest_face_index = face_areas.index(max(face_areas))
    
    face = faces[largest_face_index]
    embed = recognition.get(img_array, face)

    
    return embed

@app.post("/upload/")
async def upload_photo(file: UploadFile = File(...), name: str = Form(...), nim: str = Form(...)):
    # Ensure the photos directory exists
    if not os.path.exists(IMAGEDIR):
        os.makedirs(IMAGEDIR)
    
    file.filename = f"{name}_{nim}{os.path.splitext(file.filename)[1]}"  
    
    contents = await file.read()
    
    file_path = os.path.join(IMAGEDIR, file.filename)
    with open(file_path, "wb") as f:
        f.write(contents)
    
    return JSONResponse(status_code=201, content={"filename": file.filename, "status": "file saved successfully"})
                         

@app.post("/recognition/")
async def compare_faces(file: UploadFile = File(...)):
    image = BytesIO(await file.read())
    best_similarity = 0
    best_match = None
    imageRGB = Image.open(image).convert("RGB")
    img_array = np.array(imageRGB)
    
    faces = app_insight.get(img_array)
    folder_path = './photos'
    if len(faces) == 0:
        return JSONResponse(
                status_code=201,
                content={
                    "similarity": best_similarity,
                    "name": "unknown",
                    "NIM": 0,
                }
            )
    elif len(faces) != 0:
        
        embed_target = process_image(faces, img_array)


        
        for filename in os.listdir(folder_path):
            file_path = os.path.join(folder_path, filename)
            
            embed_source = process_image_from_file(file_path)
            
            cosine_similarity = np.dot(embed_target, embed_source) / (
                np.linalg.norm(embed_target) * np.linalg.norm(embed_source)
            )
            cosine_similarity = float(cosine_similarity)  

            if cosine_similarity > best_similarity:
                best_similarity = cosine_similarity
                best_match = filename

        if best_similarity > 0.5:
            name, id_number = os.path.splitext(best_match)[0].split('_')
            return JSONResponse(
                status_code=201,
                content={
                    "similarity": best_similarity,
                    "name": name,
                    "NIM": int(id_number),
                }
            )
        else:
            return JSONResponse(
                status_code=201,
                content={
                    "similarity": best_similarity,
                    "name": "unknown",
                    "NIM": 0,
                }
            )
        


