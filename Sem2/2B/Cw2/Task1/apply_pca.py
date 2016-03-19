import scipy.io
import compute_pca as cp
import numpy as np
from sklearn import decomposition
from matplotlib.mlab import PCA

data = scipy.io.loadmat('svhn.mat')
X=data['train_features']
(vec,val)=cp.compute_pca(X)
E2=vec[:,0:2]
egvals=val[0:2]
X_PCA=np.dot(X,E2)
print X.shape
print E2.shape
v1=E2[:,0]
v2=E2[:,1]


#sklearn_pca = sklearnPCA(n_components=2)
#sklearn_transf = sklearn_pca.fit_transform(X)
#print sklearn_transf
pca = decomposition.PCA(n_components=2)
pca.fit(X.T)
Y = pca.transform(X.T)
print Y[0:2,0:2]
print X_PCA[0:2,0:2]

#print np.isclose(sklearn_transf,X_PCA)
#print type(mlab_pca)
#np.savetxt("eigenvalues.out",egvals,delimiter=' , ')
#np.savetxt("xpca.out",X_PCA,delimiter=" ")
#np.savetxt('E2.out',E2,delimiter=',')
