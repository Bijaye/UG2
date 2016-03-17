import scipy.io
import numpy as np
def compute_pca(x):
    (N,D)=x.shape
    s=np.sum(x,axis=0)
    s=(1.0/N)*s
    s=x-s
    st=np.matrix.transpose(s)
    prod=st*s
    covariance=(1.0/N)*prod
    return covariance

data = scipy.io.loadmat('svhn.mat')
a=data['train_features']
