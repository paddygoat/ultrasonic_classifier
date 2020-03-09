#!/usr/bin/python

# cd /home/tegwyn/ultrasonic_classifier/development_stuff/ && echo whales | sudo -S python3 test_FTP_01.py

end = "\n"
RED = "\x1b[1;31m"
# BLUE='\e[44m'
F_LightGreen = "\x1b[92m"
F_Green = "\x1b[32m"
F_LightBlue = "\x1b[94m"
B_White = "\x1b[107m"
NC = "\x1b[0m" # No Color
Blink = "\x1b[5m"


import ftplib
import colorama
from colorama import Fore, Back, Style
import sys
import urllib.request

import adafruit_si7021
import busio
import board

try:
	from ADCPi import ADCPi
except ImportError:
	print("Failed to import ADCPi from python system path")
	print("Importing from parent folder instead")
	try:
		import sys
		sys.path.append('..')
		from ADCPi import ADCPi
	except ImportError:
		raise ImportError(
			"Failed to import library from parent folder")
			
adc = ADCPi(0x68, 0x69, 12)

# read from adc channels and print to screen
batteryPackRead = float(adc.read_voltage(1))*3.9194
switcherOutRead = float(adc.read_voltage(2))*1.1937

# Create library object using our bus i2c port for si7021
i2c = busio.I2C(board.SCL, board.SDA)
sensor = adafruit_si7021.SI7021(i2c)

temp_val = sensor.temperature
humid_val = sensor.relative_humidity

temp_val = round(temp_val,2)
humid_val = round(humid_val,2)
batteryPackRead = round(batteryPackRead,2)
switcherOutRead = round(switcherOutRead,2)


# round(float_num, num_of_decimals)

print('Temperature: %0.2f C' % temp_val)
print('relative humidity: %0.1f %%' % humid_val)
print('Battery pack volts: ', batteryPackRead)

myPath = '/home/tegwyn/ultrasonic_classifier/images/graphical_results/graph.png'
# myPath = '/home/tegwyn/ultrasonic_classifier/development_stuff/bat_detector.html'
# myPath = '/home/tegwyn/ultrasonic_classifier/development_stuff/weather_station_files/showdata.php'
# myPath = '/home/tegwyn/ultrasonic_classifier/development_stuff/weather_station_files/send.php'

session = ftplib.FTP('ftp.goatindustries.co.uk','paddygoat2@goatindustries.co.uk','######################')
file = open(myPath,'rb')                  # file to send

# session.storbinary('STOR bat_detector/send.php', file)     # send the file
# session.storbinary('STOR bat_detector/showdata.php', file)     # send the file
session.storbinary('STOR bat_detector/graph.png', file)     # send the file

file.close()                                    # close file and FTP

sys.stderr.write(F_LightBlue+ "..... File Sent!\n" + '\x1b[0m' + end)
session.quit()

# http://www.goatindustries.co.uk/bat_detector/graph.png
# /home/tegwyn/ultrasonic_classifier/development_stuff/bat_detector.html
# http://www.goatindustries.co.uk/bat_detector/bat_detector.html
# http://www.goatindustries.co.uk/bat_detector/showdata.php

# http://www.goatindustries.co.uk/bat_detector/send.php? temp=14.12&humidity=13.75&battery=13.97&wind=3.36
# import os
# os.system("xdg-open \"\" http://www.goatindustries.co.uk/bat_detector/send.php? temp=15.12&humidity=13.75&battery=13.97&wind=3.36")

sendPath = 'http://www.goatindustries.co.uk/bat_detector/send.php?temp='+str(temp_val)+'&humidity='+str(humid_val)+'&battery='+str(batteryPackRead)+'&wind=3.36'


# open a connection to a URL using urllib
webUrl  = urllib.request.urlopen(sendPath)

#get the result code and print it
print ("result code: " + str(webUrl.getcode()))









