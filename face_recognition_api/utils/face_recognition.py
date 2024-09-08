import cv2
import insightface
import numpy as np
import os


from fastapi import File,  HTTPException, status
from io import BytesIO
from PIL import Image
from fastapi.responses import JSONResponse
from typing import Optional

IMAGEDIR = "./source_photo"

app_insight = insightface.app.FaceAnalysis(name="buffalo_l")
app_insight.prepare(ctx_id=0, det_size=(640, 640))

recognition = insightface.model_zoo.get_model('./ml_model/w600k_r50.onnx', download=False, download_zip=False)
recognition.prepare(ctx_id=0)

def findSimilarity(contents, nim: int):
  image = BytesIO(contents)
  best_similarity = 0
  try:
    imageRGB = Image.open(image).convert("RGB")
  except IOError:
    raise HTTPException(
        status_code=status.HTTP_400_BAD_REQUEST,
        detail="Unable to read the image file"
    )
  img_array = np.array(imageRGB)


  faces = app_insight.get(img_array)
  if len(faces) == 0:
    raise HTTPException(
        status_code=status.HTTP_400_BAD_REQUEST,
        detail="face not detected"
    )
  else:
    embed_target = process_image(faces, img_array)
  
    for filename in os.listdir(IMAGEDIR):
      if str(nim) in filename:
          file_path = os.path.join(IMAGEDIR, filename)

  
    embed_source = process_image_from_file(file_path)

    cosine_similarity = np.dot(embed_target, embed_source) / (
        np.linalg.norm(embed_target) * np.linalg.norm(embed_source)
    )
    best_similarity = float(cosine_similarity)

  
  # return best_similarity
  if best_similarity > 0.5:
    return True
  else:
    return False
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