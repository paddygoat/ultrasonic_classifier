#!/usr/bin/python

# cd /home/tegwyn/ultrasonic_classifier/development_stuff/deep_learning/ && python3 determine_number_of_calls_in_specto.py


"""
 # pip3 install scikit-image 
 # pip3 install numpy==1.18
 # pip3 install scipy==1.1.0
 * Python script to demonstrate simple thresholding.
 *
 * usage: python Threshold.py <filename> <sigma> <threshold>
"""
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

# get filename, sigma, and threshold value from command line
# filename = sys.argv[1]
# filename = '/home/tegwyn/ultrasonic_classifier/images/test/noctula_1511_2_1.jpg'
# filename = '/home/tegwyn/ultrasonic_classifier/images/spectograms/noctula_1512.png'
# sigma = float(sys.argv[2])
sigma = 2
k = 2
# t = float(sys.argv[3])
t = 0.8


import cv2

# image2 = cv2.imread('/home/tegwyn/ultrasonic_classifier/images/test/noctula_1511_2_1.jpg')
# image2 = cv2.imread('/home/tegwyn/ultrasonic_classifier/images/spectograms/noctula_1512.png')
image2 = cv2.imread('/home/tegwyn/ultrasonic_classifier/images/spectograms/brandt_0.5_2169_2_3.jpg')
invert = cv2.bitwise_not(image2) # OR
# invert = 255 - image

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
im = array(Image.open('/home/tegwyn/ultrasonic_classifier/images/spectograms/noctula_1518.png').convert('L'))
im = 1*(im<128)

im = sel
im = 1*(im<256)

labels, nbr_objects = measurements.label(im)
print ("Number of objects:", nbr_objects)
