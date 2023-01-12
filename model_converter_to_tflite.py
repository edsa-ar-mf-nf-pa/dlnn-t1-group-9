
import numpy as np
import tensorflow as tf
from tensorflow import keras
from keras.models import load_model

emotional_model_folder = 'models'
emotional_model_file    = '4cnn_2fc_dropout_4_l201_sgd_01_150epochs_he_batch_256_10.h5'

model = load_model(emotional_model_folder + '\\' + emotional_model_file)
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()
open(emotional_model_folder + '\\' + emotional_model_file.replace(".h5", "") + '.tflite', "wb").write(tflite_model)
