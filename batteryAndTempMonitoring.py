#!/usr/bin/env python3

# cd /home/tegwyn/ultrasonic_classifier/ && python3 batteryAndTempMonitoring.py
"""
================================================
ABElectronics ADC Pi 8-Channel ADC demo

Requires python smbus to be installed
run with: python demo_readvoltage.py
================================================

Initialise the ADC device using the default addresses and sample rate,
change this value if you have changed the address selection jumpers

Sample rate can be 12,14, 16 or 18
"""
from __future__ import absolute_import, division, print_function, \
                                                    unicode_literals
import time
import os
import sys

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
end = "\n"
RED = "\x1b[1;31m"
BLUE='\e[44m'
F_LightGreen = "\x1b[92m"
F_Green = "\x1b[32m"
F_LightBlue = "\x1b[94m"
B_White = "\x1b[107m"
NC = "\x1b[0m" # No Color
Blink = "\x1b[5m"

stopFile = "/home/tegwyn/ultrasonic_classifier/helpers/stop.txt"
startFile = "/home/tegwyn/ultrasonic_classifier/helpers/start.txt"

nano = '4.9.140-tegra aarch64 bits'
# Pi4 = '4.19.97-v7l+ armv7l bits'
Pi4 = '4.19.97-v7l+armv7lbitsRaspbianGNU/Linux10(buster)'

text1 = '0'



def main():
	'''
	Main program function
	'''
	adc = ADCPi(0x68, 0x69, 12)

	# clear the console
	# os.system('clear')
	
	# Is the device a Raspberry Pi or a Jetson Nano ???
	file = "/home/tegwyn/ultrasonic_classifier/helpers/kernel.txt"
	with open(file) as fp:
		kernel = fp.read()
	fp.close()
	# print(kernel)
	Pi4 = '4.19.97-v7l+armv7lbitsRaspbianGNU/Linux10(buster)'
	kernel = kernel.strip('\n')                                                                    # When written to text file, a \n is added !!!!
	sys.stderr.write(F_LightBlue + "\n" + "kernel: " + kernel+ NC + end)
	# sys.stderr.write(F_LightBlue + "Pi4: " + Pi4 + NC + end)
		
	if (kernel != Pi4):   
	
		file1 = '/sys/class/thermal/thermal_zone1/temp'
		if (os.path.getsize(file1) > 0):
			with open(file1, "r") as fp:
				text1 = fp.read()
				text1 = text1.strip('\n')
		fp.close()
		#print(text1,' °C')

		file2 = '/sys/class/thermal/thermal_zone2/temp'
		if (os.path.getsize(file2) > 0):
			with open(file2, "r") as fp:
				text2 = fp.read()
				text2 = text2.strip('\n')
		fp.close()
		#print(text2,' °C')


		file3 = '/sys/class/thermal/thermal_zone3/temp'
		if (os.path.getsize(file3) > 0):
			with open(file3, "r") as fp:
				text3 = fp.read()
				text3 = text3.strip('\n')
		fp.close()
		#print(text3,' °C'	)

		file5 = '/sys/class/thermal/thermal_zone5/temp'
		if (os.path.getsize(file5) > 0):
			with open(file5, "r") as fp:
				text5 = fp.read()
				text5 = text5.strip('\n')
		fp.close()
		#print(text5,' °C')
		
	else:
		
		File0 = open('/sys/class/thermal/thermal_zone0/temp')
		temp = (File0.read())
		temp  = temp.strip('\n')
		text1 = temp
		text2 = temp
		text3 = temp
		text5 = temp
		

	# read from adc channels and print to screen
	batteryPackRead = float(adc.read_voltage(1))*3.9194
	switcherOutRead = float(adc.read_voltage(2))*1.1937
			
	#print("Channel 1: %02f" % adc.read_voltage(1))
	#print("Channel 2: %02f" % adc.read_voltage(2))
	#print("Channel 3: %02f" % adc.read_voltage(3))
	#print("Channel 4: %02f" % adc.read_voltage(4))
	#print("Channel 5: %02f" % adc.read_voltage(5))
	#print("Channel 6: %02f" % adc.read_voltage(6))
	#print("Channel 7: %02f" % adc.read_voltage(7))
	#print("Channel 8: %02f" % adc.read_voltage(8))
	#print("Channel 1: %02f" % batteryPackRead)
	#print("Channel 2: %02f" % switcherOutRead)
	# wait 0.2 seconds before reading the pins again
	# time.sleep(2)

	
	
	message = 'CPU:   ' + str(round((int(text1) + int(text2) + int(text3) + int(text5))  /400) /10) + ' °C' + '\nBattery:   ' + str(round(batteryPackRead *100)/100) + ' V' + '\nSupply:   ' + str(round(switcherOutRead *100)/100) + ' V' 
	# print(message)
	sys.stderr.write(F_LightBlue + message + NC + end)

	# message  = message.strip('\n')
	message = 'CPU: ' + str(round((int(text1) + int(text2) + int(text3) + int(text5))  /400) /10) + ' °C' + '   Battery: ' + str(round(batteryPackRead *100)/100) + ' V' + '   Supply: ' + str(round(switcherOutRead *100)/100) + ' V' 
	file6 = '/home/tegwyn/ultrasonic_classifier/helpers/battery_info.txt'
	f= open(file6, "w+")
	f.write(message)
	f.close()
	
	if (batteryPackRead > 2) and (batteryPackRead < 10.5):                                 # Create alert file if battery pack is running low.
		file7 = '/home/tegwyn/ultrasonic_classifier/helpers/batteryAlert.txt'
		f= open(file7, "w+")
		f.write(message)
		f= open(stopFile, "w+")
		if os.path.isfile(startFile):
			os.remove(startFile)
			print("start file removed")
		print("stop file created !!")
		f.close()

	if (switcherOutRead > 2) and (switcherOutRead < 4.9):                                  # Create alert file if output from switching regulator is too low.
		file7 = '/home/tegwyn/ultrasonic_classifier/helpers/batteryAlert.txt'
		f= open(file7, "w+")
		f.write(message)
		f= open(stopFile, "w+")
		if os.path.isfile(startFile):
			os.remove(startFile)
			print("start file removed")
		print("stop file created !!")
		f.close()
		
		




		

	exit

if __name__ == "__main__":
    main()
