#!/usr/bin/python

# cd /home/tegwyn/ultrasonic_classifier/ && python3 create_spectogram_batch_process.py
# cd /home/tegwyn/ultrasonic_classifier/ && chmod 775 create_spectogram_batch_process.py

# deploy_classifier_async_01.R ..... Edit line 430.
# process_audio_files.py ......... Edit line 138 to '500'

import matplotlib.pyplot as plot
from scipy.io import wavfile
import os
import sys
from matplotlib import cm
from matplotlib.colors import ListedColormap, LinearSegmentedColormap

viridis = cm.get_cmap('viridis', 256)
brg = cm.get_cmap('brg', 256)
# set1 = cm.get_cmap('set1', 256)
# tab10 = cm.get_cmap('tab10', 256)
cubehelix = cm.get_cmap('cubehelix', 256)
magma = cm.get_cmap('magma', 256)
seismic = cm.get_cmap('seismic', 256)
RdGy = cm.get_cmap('RdGy', 256)
bone = cm.get_cmap('bone', 256)
twilight = cm.get_cmap('twilight', 256)

folder1 = "/home/tegwyn/ultrasonic_classifier/"
folder2 = "/home/tegwyn/ultrasonic_classifier/processed_audio/"
folder3 = "/home/tegwyn/ultrasonic_classifier/unknown_bat_audio/"
folder4 = "/home/tegwyn/ultrasonic_classifier/my_audio"
file3 = '/home/tegwyn/ultrasonic_classifier/helpers/count.txt'
file4 = '/home/tegwyn/ultrasonic_classifier/helpers/bat_name.txt'

# file_to_process = "/home/tegwyn/ultrasonic_classifier/unknown_bat_audio/filtered.wav"

if os.path.isfile(file3):
	with open(file3) as fp:
		count = fp.readline()
		print("count = ",count)
else:
    count = '0'

if os.path.isfile(file4):
	with open(file4) as fp:
		bat_name = fp.readline()
		print("bat_name = ",bat_name)

directory = os.fsencode("/home/tegwyn/ultrasonic_classifier/unknown_bat_audio/")
for file in os.listdir(directory):                                       # This loop will carry on going as long as there are more files to process.
    filename = os.fsdecode(file)
    if filename.endswith(".wav"):
        print(filename)
        file_to_process = os.path.join(folder3, filename)
        print(file_to_process)

if os.path.isfile(file_to_process):
	print("From create_spectogram_batchprocess .... We found a wav file filtered.wav ....... ")
	samplingFrequency, signalData = wavfile.read(file_to_process)
	# plot.rcParams['figure.figsize'] = [6.5, 5.5]
	# plot.rcParams['figure.figsize'] = [80, 20]    # about 16:4 .... 4:1 .... for square 'pixels' ........ 0.5 seconds
	plot.rcParams['figure.figsize'] = [24, 10]    # 0.125 seconds chunk size
	print("one")
	# plot.rcParams['figure.figsize'] = [10, 35]    # 0.125 seconds chunk size
	plot.subplot(211)
	NFFT = 1024
	# NFFT = 2048
	# noverlap=2046
	noverlap=1018
	dpi = 300
	print("two")
	# plot.specgram(signalData, NFFT=NFFT, Fs=samplingFrequency, noverlap=noverlap, cmap='twilight')
	plot.specgram(signalData, NFFT=NFFT, Fs=samplingFrequency, noverlap=noverlap)
	# plot.specgram(signalData,Fs=samplingFrequency)
	# plot.xlabel('Time, seconds')
	# plot.ylabel('Frequency')
	plot.savefig('/home/tegwyn/ultrasonic_classifier/images/spectograms/'+ bat_name + str(count) + '.png', bbox_inches='tight', dpi=dpi)          # This will save spectograms with descrete filenames.
	print("three")
	count2 = int(count)+1
	print("count2 = ",count2)

	file = file3
	f= open(file, "w+")
	f.write(str(count2))
	f.close()
	# plot.savefig('/home/tegwyn/ultrasonic_classifier/images/spectograms/specto.png', bbox_inches='tight')                          # This will save just the current spectogram.
	# plot.show()
	
# sys.exit()
# Exit with status os.EX_OK 
# using os._exit() method 
# The value of os.EX_OK is 0         
os._exit(os.EX_OK)

# The graph.png image size is a combination of the dpi and figsize.
# fig.savefig('/home/tegwyn/ultrasonic_classifier/images/graphical_results/graph.png', bbox_inches='tight', dpi=80)

