import scipy.io
import numpy as np
import numpy.testing as npt
def compute_pca(x):
    (N,D)=x.shape
    s=np.sum(x,axis=0)
    s=(1.0/N)*s
    s=x-s
    st=np.matrix.transpose(s)
    prod=np.dot(st,s)
    #covariance matrix
    covariance=(1.0/(N-1))*prod
    (EVals,EVecs)=np.linalg.eig(covariance)
    ev=np.argsort(EVals)
    ev=ev[::-1]
    EVecs=EVecs[:,ev]
    EVals=EVals[ev]
    for i in range(0,D):
        if EVecs[0,i]<0:
            EVecs[:,i]*=-1
    return (EVecs,EVals)



def my_cov(x):
    (N,D)=x.shape
    s=np.sum(x,axis=0)
    s=(1.0/N)*s
    s=x-s
    st=np.matrix.transpose(s)
    prod=np.dot(st,s)
    #covariance matrix
    covariance=(1.0/(N-1))*prod
    return covariance

data = scipy.io.loadmat('svhn.mat')
X=data['train_features']

#np.savetxt('co.out',co,delimiter=',')
#np.savetxt('mine.out',my,delimiter=',')
