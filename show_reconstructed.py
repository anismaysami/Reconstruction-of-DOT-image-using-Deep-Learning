

#This script reconstruct DOT images
import matplotlib.pyplot as plt
from superscript import get_super
def reconstruction(model, model_name, index, data, realmua, width, height):
    #data is our measurement
    #realmua is real mua
    mua_hat=model.predict(data) # mua_hat is predicted mua by MLP_model

    
    #display predicted by our model
    plt.subplot(211)
    print(max(mua_hat[index]))
    plt.imshow(mua_hat[index].reshape(width,height))
    title_1="Predicted by {}".format(model_name)
    plt.title(title_1)
    #plt.colorbar()
    
    #displays ground truth
    maximum_value_mua=max(realmua[index])
    plt.subplot(212)
    plt.imshow(realmua[index].reshape(width,height))
    title_2='Ground truth - \u03BCa={} mm{}'.format(maximum_value_mua, get_super("-1"))
    plt.title(title_2)

    plt.subplots_adjust(bottom=0.2, right=0.5, top=0.9)
    cax = plt.axes([0.85, 0.1, 0.075, 0.8])
    plt.colorbar(cax=cax)
    plt.tight_layout()
    #plt.colorbar()
    #plt.subplots_adjust(bottom=0.1, right=0.8, top=0.9)
