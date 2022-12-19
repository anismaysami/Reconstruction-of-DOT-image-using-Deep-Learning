# -*- coding: utf-8 -*-
"""
Created on Mon Dec 12 23:04:01 2022

@author: Anis Maysami
Bio-optical imaging labratory 
Shahid Beheshti University
"""
#This function createss a fully connected neural network (MLP_MODEL) (MASTER)
#convoloutional neural network (DOT_convnet) (MASTER)
#single layer neural network (Single_layer) (MASTER)
#convoloutional neural network (cnn_2)


#Importing needed packages
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, ReLU, BatchNormalization, Dropout, Conv2D, MaxPool2D, Flatten, Reshape, Activation, GaussianNoise, AvgPool2D, Conv1D, GlobalAveragePooling2D, concatenate

#%%
def MLP_model():
  #define model
  #input=data_train.shape[1]
  model=Sequential()
  #model.add(Dense(625, activation='relu', input_shape=(625,)))
  model.add(Dense(256, activation='relu', input_shape=(625,)))#, kernel_initializer='he_uniform'))
  model.add(GaussianNoise(0.1))
  #model.add(Dropout(0.2))
  model.add(Dense(256, activation='relu'))#,kernel_initializer='he_uniform'))
  #model.add(Dense(512, activation='relu'))
  #model.add(Dropout(0.2))
  #model.add(BatchNormalization())
  model.add(Dense(625, activation='relu'))#,kernel_initializer='he_uniform'))
  model.add(Dense(625, activation='relu'))#,kernel_initializer='he_uniform'))
  model.add(Dense(625, activation='relu'))#,kernel_initializer='he_uniform'))
  #model.add(BatchNormalization())
  model.add(Dense(625, activation='relu'))#,kernel_initializer='he_uniform'))
  model.add(Dense(1024, activation='relu'))#,kernel_initializer='he_uniform'))
  #model.add(Dense(1024, activation='relu', kernel_initializer='he_uniform'))
  #model.add(BatchNormalization())
  model.add(Dense(4096, activation='relu'))
  #compile model
  #opt=SGD()
  model.compile( loss='mean_squared_error', optimizer='adam' ,metrics=['mean_absolute_error'])
  #round(model.optimizer.lr.numpy(), 5)
  model.summary()
  return  model
#%%
def DOT_convnet():
  model=Sequential()
  model.add(Conv2D(32,(2,2),activation='relu', padding='same', input_shape=(25,25,1)))
  model.add(Conv2D(32,(2,2),activation='relu', padding='same'))
  model.add(MaxPool2D(pool_size=(2,2), strides=2))
  model.add(Conv2D(64,(3,3),activation='relu', padding='same'))
  model.add(Conv2D(64,(3,3),activation='relu', padding='same'))
  model.add(MaxPool2D(pool_size=(2,2), strides=2))
  #model.add(Conv2D(64,(2,2),activation='relu'))
  #model.add(MaxPooling2D(pool_size=(2,2)))
  #model.add(Conv2D(128,(5,5),activation='relu',padding='same'))
  #model.add(Conv2D(128,(5,5),activation='relu',padding='same'))
  #model.add(MaxPool2D(pool_size=(2,2), strides=2))
  model.add(Flatten())
  model.add(Dense(625, activation='relu'))
  #model.add(Dropout(0.2))
  model.add(Dense(4096, activation='relu'))
  model.compile(loss='mean_squared_error', optimizer='adam', metrics=['mae'])
  model.summary()
  return model
#%%
def Single_layer():
  #define model
  #input=data_train.shape[1]
  model=Sequential()
  #model.add(Dense(256, activation='relu',input_shape=(625,)))#, kernel_initializer='he_uniform'))
  #model.add(GaussianNoise(0.1))
  model.add(Dense(1024, activation='relu',input_shape=(625,)))
  model.add(Dense(4096, activation='relu'))#,kernel_initializer='he_uniform' ))
  #opt=SGD(lr=0.01, momentum=0.99, decay=0.001)
  model.compile(loss='mean_squared_error', optimizer='adam',  metrics=['mean_absolute_error'])
  #round(model.optimizer.lr.numpy(), 5)
  model.summary()
  return  model
#%%
def dense_conv():
  model=Sequential()
  #model.add(Dense(256, activation='relu', input_shape=(625,)))
  #model.add(GaussianNoise(0.1))
  model.add(Dense(625,  activation='relu',input_shape=(625,)))
  model.add(GaussianNoise(0.1))
  #model.add(Dropout(0.2))
  model.add(Reshape((25,25,1)))

  #model.add(Conv1D(32,2, activation='relu', padding='same'))
  #model.add(Conv1D(32,2, activation='relu', padding='same'))
  #model.add(Reshape((25,25)))
  model.add(Conv2D(32,(3,3),activation='relu', padding='same'))
  model.add(Conv2D(32,(3,3),activation='relu', padding='same'))
  model.add(MaxPool2D(pool_size=(2,2), strides=2))
  model.add(Conv2D(64,(5,5),activation='relu', padding='same'))
  model.add(Conv2D(64,(5,5),activation='relu', padding='same'))
  model.add(MaxPool2D(pool_size=(2,2), strides=2))
  #model.add(Conv2D(64,(7,7),activation='relu', padding='same'))
  #model.add(Conv2D(64,(7,7),activation='relu', padding='same'))
  model.add(Flatten())
  #model.add(Dense(625, activation='relu'))
  #model.add(Dropout(0.2))
  model.add(Dense(4096, activation='relu'))
  model.compile(loss='mean_squared_error', optimizer='adam', metrics=['mae'])
  model.summary()
  return model
#%%
def cnn_2():
  model=Sequential()
  model.add(Conv2D(32,(1,1),activation='relu',strides=1, padding='same',input_shape=(25,25,1)))
  model.add(MaxPool2D((2,2)))
  for i in range(6):
     model.add(Conv2D(128,(1,1),activation='relu',strides=1, padding='same'))
     model.add(Conv2D(64,(3,3),activation='relu',strides=1, padding='same'))

  model.add(Conv2D(32,(1,1),activation='relu'))
  model.add(AvgPool2D((2,2),(2,2),padding='same'))
  for i in range(12):
     model.add(Conv2D(128,(1,1),activation='relu',strides=1, padding='same'))
     model.add(Conv2D(64,(3,3),activation='relu',strides=1, padding='same'))

  model.add(Conv2D(32,(1,1), activation='relu'))
  model.add(AvgPool2D((2,2),(2,2),padding='same'))  
  for i in range(24):
     model.add(Conv2D(128,(1,1),activation='relu',strides=1, padding='same'))
     model.add(Conv2D(64,(3,3),activation='relu',strides=1, padding='same'))

  model.add(Conv2D(32,(1,1), activation='relu'))
  model.add(AvgPool2D((2,2),(2,2),padding='same'))

  #for i in range(16):
     #model.add(Conv2D(128,(1,1),activation='relu',strides=1, padding='same'))
     #model.add(Conv2D(64,(3,3),activation='relu',strides=1, padding='same'))

  model.add(Conv2D(32,(1,1),activation='relu'))
  model.add(AvgPool2D((2,2),(2,2),padding='same')) 
  model.add(Dense(625, activation='relu'))
  model.add(Dropout(0.2))
  model.add(Dense(4096, activation='relu'))

  model.compile(loss='mean_squared_error', optimizer='adam', metrics=['mae'])
  model.summary()

  return model
