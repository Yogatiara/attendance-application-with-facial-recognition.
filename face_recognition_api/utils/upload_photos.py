import os
import uuid
from fastapi import File


SOURCEIMAGEDIR = "./source_photo"
TARGETIMAGEDIR = "./target_photo"

async def uploadSourcePhotos(file : File, name :str, nim: int):
  if not os.path.exists(SOURCEIMAGEDIR):
    os.makedirs(SOURCEIMAGEDIR)

  fileName = f"{name}_{str(nim)}{os.path.splitext(file.filename)[1]}"
  file.filename = fileName
  contents = await file.read()

  file_path = os.path.join(SOURCEIMAGEDIR, file.filename)
  with open(file_path, "wb") as f:
    f.write(contents)

  return fileName


def uploadTargetPhotos(file : File, contents, name: str, nim: int, action: str):
    if not os.path.exists(TARGETIMAGEDIR):
        os.makedirs(TARGETIMAGEDIR)


    
    file_extension = os.path.splitext(file.filename)[1]  
    fileName = f"{name}_{str(nim)}_{action}_{uuid.uuid4().hex}{file_extension}"
    
    file_path = os.path.join(TARGETIMAGEDIR, fileName)
    
    # contents = await file.read()
    with open(file_path, "wb") as f:
        f.write(contents)

    return fileName

  