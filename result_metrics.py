#This script shows the result of reconstruction
#written by Anis maysami
from metrics import MAE, MSE, PSNR, SSIM
def evaluation(model, index, data, realmua):
  y_pred=model.predict(data)
  y_pred_index=y_pred[index].reshape(64,64)
  y_test=realmua[index].reshape(64,64)

  mae=MAE(y_test, y_pred_index)
  mse=MSE(y_test, y_pred_index)
  psnr=PSNR(y_test, y_pred_index)
  print('Mean Absolute Error:', mae)
  print('Mean Squared Error:', mse)
  print('Peak Signal to Noise Ratio:', psnr)