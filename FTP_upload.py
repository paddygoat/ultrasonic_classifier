#!/usr/bin/python
# pip3 install ftputil
# cd /home/tegwyn/ultrasonic_classifier/ && echo whales | sudo -S python3 FTP_upload.py

end = "\n"
RED = "\x1b[1;31m"
# BLUE='\e[44m'
F_LightGreen = "\x1b[92m"
F_Green = "\x1b[32m"
F_LightBlue = "\x1b[94m"
B_White = "\x1b[107m"
NC = "\x1b[0m" # No Color
Blink = "\x1b[5m"

import subprocess
import time
import ftputil
import os
import glob
import ftplib
import colorama
from colorama import Fore, Back, Style
import sys
import urllib.request

import adafruit_si7021
import busio
import board
import datetime

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
	
sys.stderr.write(str(datetime.datetime.now())+ '\n')
		
adc = ADCPi(0x68, 0x69, 12)

# Define command and arguments
command = 'Rscript'
command_python = "python3"
command_bash = "bash"

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

sys.stderr.write(str(datetime.datetime.now())+ '\n')

file3 = '/home/tegwyn/ultrasonic_classifier/helpers/CPU_temp.txt'
if (os.path.getsize(file3) > 0):
    with open(file3, "r") as fp:
        CPU_temp = fp.read()
        CPU_temp = CPU_temp.strip('\n')
fp.close()
print("CPU temp:",CPU_temp)

myPath = '/home/tegwyn/ultrasonic_classifier/images/graphical_results/graph.png'
session = ftplib.FTP('##################','##################','##################')
file = open(myPath,'rb')                  # file to send
# session.storbinary('STOR bat_detector/send.php', file)     # send the file
# session.storbinary('STOR bat_detector/showdata.php', file)     # send the file
session.storbinary('STOR bat_detector/graph.png', file)      # send the file
file.close()                                                 # close file and FTP
sys.stderr.write(F_LightBlue+ "..... graph.png file Sent!\n" + '\x1b[0m' + end)
session.quit()

# myPath = '/home/tegwyn/ultrasonic_classifier/development_stuff/bat_detector.html'
# myPath = '/home/tegwyn/ultrasonic_classifier/development_stuff/weather_station_files/showdata.php'


myPath = '/home/tegwyn/ultrasonic_classifier/From_R_01.csv'
session = ftplib.FTP('##################','##################','##################')
file = open(myPath,'rb')                                    # file to send
session.storbinary('STOR bat_detector/results.csv', file)     # send the file
file.close()                                                # close file and FTP
sys.stderr.write(F_LightBlue+ "..... From_R_01.csv file Sent!\n" + '\x1b[0m' + end)
session.quit()

myPath = '/home/tegwyn/ultrasonic_classifier/IOT_stuff/html/saved_audio_files.html'
session = ftplib.FTP('##################','##################','##################')
file = open(myPath,'rb')                                    # file to send
session.storbinary('STOR bat_detector/saved_audio_files.html', file)     # send the file
file.close()                                                # close file and FTP
sys.stderr.write(F_LightBlue+ "..... saved_audio_files.html file Sent!\n" + '\x1b[0m' + end)
session.quit()

# myPath = '/home/tegwyn/ultrasonic_classifier/results/'
session = ftplib.FTP('##################','##################','##################')
# dir = 'bat_detector/results'
# session.mkd(dir)
# file = open(myPath,'rb')                                    # file to send
# session.storbinary('STOR bat_detector/results/37%_UFO_15-03-2020_11:54:32.txt', file)     # send the file

for root, dirs, files in os.walk('/home/tegwyn/ultrasonic_classifier/results/'):
    for fname in files:
        full_fname = os.path.join(root, fname)
        session.storbinary('STOR bat_detector/results/' + fname, open(full_fname, 'rb'))

file.close()                                                # close file and FTP
sys.stderr.write(F_LightBlue+ "..... html results file Sent!\n" + '\x1b[0m' + end)
session.quit()



# Delete old files off the FTP server:
sys.stderr.write(F_LightBlue+ "Opening FTP connection and check for file deletion ...." + '\x1b[0m')

host = ftputil.FTPHost('##################','##################','##################')
mypath = 'bat_detector/results'
now = time.time()
host.chdir(mypath)
names = host.listdir(host.curdir)
# 86400 seconds = 1 day

for name in names:
    if host.path.getmtime(name) < (now - (86400)):
      if host.path.isfile(name):
         print(name)
         print(host.path.getmtime(name),',',now,',',now - host.path.getmtime(name) )
         host.remove(name)
         sys.stderr.write(F_LightBlue+ "DELETED" + '\x1b[0m')
    else:
      sys.stderr.write(F_LightBlue+ "." + '\x1b[0m')
sys.stderr.write(F_LightBlue+ "Closing FTP connection" + '\x1b[0m'+'\n')
host.close()


sendPath = '##################?temp='+str(temp_val)+'&humidity='+str(humid_val)+'&battery='+str(batteryPackRead)+'&CPU_temp='+str(CPU_temp)
# open a connection to a URL using urllib
webUrl  = urllib.request.urlopen(sendPath)
#get the result code and print it
print ("result code: " + str(webUrl.getcode()))


# Delete all files from results directory:
files = glob.glob('/home/tegwyn/ultrasonic_classifier/results/*')
for f in files:
    os.remove(f)


# Build subprocess command for running modem.sh:
path2script = '/home/tegwyn/ultrasonic_classifier/modem.sh'
cmd = [command_bash, path2script]
x = subprocess.Popen(cmd)                                       # This is where the modem program is called.

sys.stderr.write(str(datetime.datetime.now())+ '\n')

exit()
