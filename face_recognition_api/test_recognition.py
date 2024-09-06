
import cv2
import insightface
import numpy as np
from insightface.app import FaceAnalysis

app = FaceAnalysis(name="buffalo_l")
app.prepare(ctx_id=0, det_size=(640, 640))

img = cv2.imread("test.png")
img2 = cv2.imread(".test.png")
print(img)

faces = app.get(img)
faces2 = app.get(img2)

recognition = insightface.model_zoo.get_model('./model/w600k_r50.onnx', download =False, download_zip = False)
recognition.prepare(ctx_id=0)



face_areas = [(face.bbox[2] - face.bbox[0]) * (face.bbox[3] - face.bbox[1]) for face in faces]
face_areas2 = [(face.bbox[2] - face.bbox[0]) * (face.bbox[3] - face.bbox[1]) for face in faces2]

largest_face_index = face_areas.index(max(face_areas))
largest_face_index2 = face_areas2.index(max(face_areas2))

faces = [faces[largest_face_index]]
faces2 = [faces2[largest_face_index2]]

embed = recognition.get(img, faces[0])
embed2 = recognition.get(img2, faces2[0])

cosine_similarity = np.dot(embed, embed2) / (np.linalg.norm(embed) * np.linalg.norm(embed2))

print(embed2)


print(cosine_similarity)
if cosine_similarity > 0.5:
    print("Wajah sama")
else:
    print("Wajah berbeda")