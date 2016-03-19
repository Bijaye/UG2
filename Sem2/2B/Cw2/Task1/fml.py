import numpy as np
import matplotlib.pyplot as plt
import scipy.io
data = scipy.io.loadmat('svhn.mat')
x=data['train_features']

(N,D)=x.shape
s=np.sum(x,axis=0)
s=(1.0/N)*s
s=x-s
# data = (data - mu)/data.std(axis=0)  # Uncomment this reproduces mlab.PCA results
eigenvectors, eigenvalues, V = np.linalg.svd(
    s.T, full_matrices=False)
projected_data = np.dot(s, eigenvectors)
print projected_data.shape
