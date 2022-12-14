# -*- coding: utf-8 -*-
"""
Created on Tue Dec 13 14:09:07 2022

@author: Anis Maysami
"""
#This function calculate evaluate metrics

#importing needed packages
import numpy as np
from skimage.metrics import structural_similarity

#Calculating Mean Absolute Error
def MAE(y_pred, y_test):
    """  Mean absolute error """
    mae = np.sum(np.abs(y_test - y_pred)) / (y_test.shape[0] * y_test.shape[1])
    return mae

#Calculating Mean Squared Error    
def MSE(y_pred, y_test):
    """ Mean Squared Error """
    mse = np.sum((y_test - y_pred) ** 2) / (y_test.shape[0] * y_test.shape[1])
    return mse

#Calculating Peak Signal to Noise Ratio     
def PSNR(y_pred, y_true):
  mse=MSE(y_pred, y_true)
  maxi=np.max(y_pred)
  psnr=10*np.log10((maxi**2)/mse)
  return psnr

#Calculating structural similarity index
def SSIM(y_test_i, y_pred_i):
  " Structutal Similarity Index "
  s, m = structural_similarity(y_test_i, y_pred_i, data_range=(y_test_i.max() - y_test_i.min()), full=True)
  return s,m