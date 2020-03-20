#!/usr/bin/python

# cd /home/tegwyn/ultrasonic_classifier/development_stuff/deep_learning/ && python3 determine_number_of_calls_in_specto_2.py


"""
 # pip3 install scikit-image 
 # pip3 install numpy==1.18
 # pip3 install scipy==1.1.0
 * Python script to demonstrate simple thresholding.
 *
 * usage: python Threshold.py <filename> <sigma> <threshold>
"""
import os
import sys
import numpy as np
import skimage.color
import skimage.filters
import skimage.io
import skimage.viewer

from scipy.ndimage import measurements,morphology
from numpy import array
from PIL import Image
from numpy import *
from scipy.ndimage import filters
import cv2

# sigma = float(sys.argv[2])
sigma = 2

k = 2
k = 40
k = 30
k = 20
k = 22       # Higher value gives more deleted files

# t = float(sys.argv[3])
t = 0.8
t = 0.1

t_rescaled = 0.31
t_rescaled = 0.29

path = '/home/tegwyn/ultrasonic_classifier/development_stuff/deep_learning/test_2/'

path, dirs, files = next(os.walk(path))
file_count = len(files)
print (file_count)
i=0

for filename in os.listdir(path):
    print (file_count,filename)
    file_count = file_count -1
    
    image2 = cv2.imread(path + filename)      ###### SOMETHING

    invert = cv2.bitwise_not(image2)

    # display the result
    # viewer = skimage.viewer.ImageViewer(invert)
    # viewer.show()

    # blur and grayscale before thresholding
    blur = skimage.color.rgb2gray(invert)

    # display the result
    # viewer = skimage.viewer.ImageViewer(blur)
    # viewer.show()

    blur = skimage.filters.gaussian(blur, sigma=k)

    # display the result
    # viewer = skimage.viewer.ImageViewer(blur)
    # viewer.show()

    t_rescaled = 0.31

    # perform inverse binary thresholding
    mask = blur < t_rescaled

    # display the result
    # viewer = skimage.viewer.ImageViewer(mask)
    # viewer.show()

    # use the mask to select the "interesting" part of the image
    sel = np.zeros_like(invert)
    sel[mask] = invert[mask]

    # display the result
    # viewer = skimage.viewer.ImageViewer(sel)
    # viewer.show()

    # load image and threshold to make sure it is binary
    im = array(Image.open(path + filename).convert('L'))
    # im = 1*(im<128)

    im = sel
    # im = 1*(im<256)

    labels, nbr_objects = measurements.label(im)
    print ("Number of objects:", nbr_objects)
    
    if nbr_objects < 1:
        print ("DELETE !!!",filename)
        os. remove(path + filename)

