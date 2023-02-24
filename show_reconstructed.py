
#This script reconstruct DOT images
import matplotlib.pyplot as plt
from superscript import get_super
def reconstruction(model, index, data, realmua, width, height):
    #data is our measurement
    #realmua is real mua
    mua_hat=model.predict(data) # mua_hat is predicted mua by MLP_model

    
    #display predicted by our model
    fig,ax = plt.subplots(1,2)
    ax[0,0].imshow(mua_hat[index].reshape(width,height))
    title_1=print(f"Predicted by {model}")
    ax[0,0].set_title(title_1)
    
    #displays ground truth
    maximum_value_mua=max(realmua)
    ax[0,1].imshow(realmua.reshape(width,height))
    title_2='Ground truth compared to {} - \u03BCa={} mm{}'.format(model, maximum_value_mua, get_super("-1"))
    ax[0,1].title(title_2)
    fig.colorbar()
