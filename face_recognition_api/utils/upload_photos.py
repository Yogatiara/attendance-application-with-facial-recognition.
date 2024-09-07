import os
from fastapi import File


IMAGEDIR = "./photos"

async def uploadPhotos(file : File, name :str, nim: int):
  if not os.path.exists(IMAGEDIR):
    os.makedirs(IMAGEDIR)

  fileName = f"{name}_{str(nim)}{os.path.splitext(file.filename)[1]}"
  file.filename = fileName
  contents = await file.read()

  file_path = os.path.join(IMAGEDIR, file.filename)
  with open(file_path, "wb") as f:
    f.write(contents)

  return fileName

  