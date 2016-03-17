import scipy.io
import numpy as np
def compute_pca(x):
    (N,D)=x.shape
    s=np.sum(x,axis=0)
    s=(1.0/N)*s
    s=x-s
    st=np.matrix.transpose(s)
    prod=np.dot(st,s)
    #covariance matrix
    covariance=(1.0/N)*prod
    (EVals,EVecs)=np.linalg.eig(covariance)
    ev=np.argsort(EVals)
    ev=ev[::-1]
    EVecs=EVecs[:,ev]
    for i in range(0,D):
        if EVecs[0,i]<0:
            EVecs[:,i]*=-1
    return (EVecs,EVals)

data = scipy.io.loadmat('svhn.mat')
a=data['train_features']
(vec,val)=compute_pca(a)
np.savetxt('vec.out', vec, delimiter=',')
np.savetxt('val.out', val, delimiter=',')
