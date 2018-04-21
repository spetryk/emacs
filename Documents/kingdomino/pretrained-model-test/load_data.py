"""From our images, make data loader into keras compatible format
   for transfer learning on densenet-121"""
import numpy as np
from sklearn.model_selection import train_test_split
import os
import matplotlib.pyplot as plt
import glob

import cv2
from keras.datasets import cifar10
from keras import backend as K
from keras.utils import np_utils


def get_train_test(train_dir, img_rows, img_cols):
    """
    train_dir: directory where training data is held.
    img_rows, img_cols: resolution of image (e.g. 64, 64)

    Example train_dir format:
    train_dir
       -- water_0
          -- img0.jpg
          -- img1.jpg
       -- forest_0
          -- img27.jpg
          -- img28.jpg
    Returns:
    x_train, x_test, y_train, y_test
    x_train, x_test: uint8 array of RGB image data with shape (num_samples, 3, img_rows, img_cols).
    y_train, y_test: uint8 array of category labels (integers in range 0-9) with shape (num_samples,)
"""

    data_dir = train_dir + '/**/*.jpg'
    file_list = glob.glob(data_dir)

    labels = list(map(lambda filename: filename.split(os.sep)[1], file_list))
    labels = np.array(labels)

    _, labels = np.unique(labels, return_inverse=True)
    labels = np.array(labels, dtype='uint8')

    imgs = list(map(plt.imread, file_list))

    # Resize images to have 3 channels for future work with color
    imgs = list(map(lambda x: np.resize(x, (img_rows, img_cols, 3)), imgs))
    imgs = np.array(imgs, dtype='uint8')

    X_train, X_test, y_train, y_test = train_test_split(
        imgs, labels, test_size=0.25, random_state=42, shuffle=True)

    print(X_train.shape, X_test.shape, y_train.shape, y_test.shape)

    return X_train, X_test, y_train, y_test


def load_data(train_dir, img_rows, img_cols):

    # Load custom training and validation sets
    X_train, X_valid, Y_train, Y_valid = get_train_test(train_dir, img_rows, img_cols)

    nb_train_samples = X_train.shape[0]
    nb_valid_samples = X_valid.shape[0]
    num_classes = 2 # TODO: hard-coded

    # Resize trainging images
    if K.image_dim_ordering() == 'th':
        X_train = np.array([cv2.resize(img.transpose(1,2,0), (img_rows,img_cols)).transpose(2,0,1) for img in X_train[:nb_train_samples,:,:,:]])
        X_valid = np.array([cv2.resize(img.transpose(1,2,0), (img_rows,img_cols)).transpose(2,0,1) for img in X_valid[:nb_valid_samples,:,:,:]])
    else:
        X_train = np.array([cv2.resize(img, (img_rows,img_cols)) for img in X_train[:nb_train_samples,:,:,:]])
        X_valid = np.array([cv2.resize(img, (img_rows,img_cols)) for img in X_valid[:nb_valid_samples,:,:,:]])

    # Transform targets to keras compatible format
    Y_train = np_utils.to_categorical(Y_train[:nb_train_samples], num_classes)
    Y_valid = np_utils.to_categorical(Y_valid[:nb_valid_samples], num_classes)

    return X_train, Y_train, X_valid, Y_valid


