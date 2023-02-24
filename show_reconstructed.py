
#This script reconstruct DOT images
import matplotlib.pyplot as plt
from superscript import get_super
def reconstruction(model, index, data, realmua, width, height):
    #data is our measurement
    #realmua is real mua
    mua_hat=model.predict(data) # mua_MLP_hat is predicted mua by MLP_model

    
    #display predicted by MLP_model
    plt.subplot(1,2)
    plt.imshow(mua_hat[index].reshape(width,height))
    title_1=print(f"Predicted by {model}")
    plt.title(title_1)
    plt.colorbar()
    
    #displays ground truth
    maximum_value_mua=max(realmua)
    plt.imshow(realmua.reshape(width,height))
    title_2='Ground truth compared to MLP model - \u03BCa={} mm{}'.format(maximum_value_mua, get_super("-1"))
    plt.title(title_2)
    plt.colorbar()
