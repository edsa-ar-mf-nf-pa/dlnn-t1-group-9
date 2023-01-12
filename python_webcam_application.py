
### Import Section

import tensorflow
from tensorflow import _keras
from keras.models import load_model
from time import sleep
from tensorflow.keras.utils import img_to_array
from keras.preprocessing import image
import cv2 
import numpy as np


### Configuration Section 

frontal_face_identifier = 'models/haarcascade_frontalface_default.xml'  # Object Detection Algorithm used to identify faces in an image or a real time video
emotional_model_file    = 'models/4cnn_2fc_dropout_4_l201_sgd_01_150epochs_he_batch_256_10.h5'
class_labels            = ['Angry','Disgust', 'Fear', 'Happy','Neutral','Sad','Surprise']

face_classifier=cv2.CascadeClassifier(frontal_face_identifier)
emotion_model = load_model(emotional_model_file)

cap=cv2.VideoCapture(0)

while True:

    # read returns a tuple (return value, frame/image)
    # Convert frame to gray scale
    return_result,frame = cap.read()

    gray = cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
    faces = face_classifier.detectMultiScale(gray,1.3,5)

    # Each face provide the positions
    # Print the rectangle over the face present
    # Convert the frame to the correct size (48, 48)
    for (x,y,w,h) in faces:
        cv2.rectangle(frame,(x,y),(x+w,y+h),(255,0,0),2)
        roi_gray = gray[y:y+h,x:x+w]
        roi_gray = cv2.resize(roi_gray,(48,48),interpolation=cv2.INTER_AREA)

        #Get image ready for prediction
        roi = roi_gray.astype('float') #/255.0  # Uncomment this if the model don't rescale itself
        roi = img_to_array(roi)
        roi = np.expand_dims(roi,axis=0)  # Expand dims to get it ready for prediction (1, 48, 48, 1)

        preds = emotion_model.predict(roi)[0]  # Yields one hot encoded result for 7 classes
        label = class_labels[preds.argmax()]  # Find the label
        label_position=(x,y)
        cv2.putText(frame,label,label_position,cv2.FONT_HERSHEY_SIMPLEX,1,(0,255,0),2)
        
    cv2.imshow('Emotion Detector', frame)
    if cv2.waitKey(1) & 0xFF == ord('s'):
        break

cap.release()
cv2.destroyAllWindows()