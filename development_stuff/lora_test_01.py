#!/usr/bin/python

# cd /home/tegwyn/ultrasonic_classifier/development_stuff/ && echo whales | sudo -S python3 lora_test_01.py
# cd /home/tegwyn/ultrasonic_classifier/development_stuff/ && python3 lora_test_01.py
# cd /home/tegwyn/ultrasonic_classifier/development_stuff/ && chmod 775 test.py


import time
import busio
import digitalio
import board
import adafruit_si7021
from adafruit_tinylora.adafruit_tinylora import TTN, TinyLoRa

import colorama
from colorama import Fore, Back, Style
import sys
import pandas as pd
import os.path

end = "\n"
RED = "\x1b[1;31m"
# BLUE='\e[44m'
F_LightGreen = "\x1b[92m"
F_Green = "\x1b[32m"
F_LightBlue = "\x1b[94m"
B_White = "\x1b[107m"
NC = "\x1b[0m" # No Color
Blink = "\x1b[5m"


bat_species_val = 2
bat_species_val = [0,0,0,0,0,0,0,0]
total_audio_events = [0,0,0,0,0,0,0,0]

df = pd.read_csv("/home/tegwyn/ultrasonic_classifier/From_R_01.csv")

print("")
print(df)

total_S_PIP = df['S_PIP'].sum()
print("total_S_PIP = ",total_S_PIP )
print("")


n = len(df.columns)                           # get the number of columns.
number_of_species_detected = n - 1            # One of the columns is labelled 'BLANK'.
for index, row in df[:1].iterrows():          # we check only 1 row in the dataframe
    for i in range(1,n):
        bat_name = row.index[i]
        print(bat_name)
        total_audio_events[i-1] = df[bat_name].sum()
        print(total_audio_events[i-1])
        
        # convert bat name to a number between 0 and 65,536:
        # These must be in aphabetic order!
        if bat_name == "C_PIP":
            bat_species_val[i-1] = 17
        if bat_name == "HOUSE_KEYS":
            bat_species_val[i-1] = 26
        if bat_name == "PLECOTUS":
            bat_species_val[i-1] = 35
        if bat_name == "RHINO_HIPPO":
            bat_species_val[i-1] = 71
        if bat_name == "S_PIP":
            bat_species_val[i-1] = 92



print("")
# sys.stderr.write('\x1b[1;31m' + "/nStart of LoRa !!!!" + '\x1b[0m' + end)
# sys.stderr.write(F_LightBlue+ "Start of LoRa !!!!" + '\x1b[0m' + end)

# print("Hello blinka!")

# Try to great a Digital input
pin = digitalio.DigitalInOut(board.D4)
# print("Digital IO ok!")

# Try to create an I2C device
i2c = busio.I2C(board.SCL, board.SDA)
# print("I2C ok!")

# Try to create an SPI device
spi = busio.SPI(board.SCLK, board.MOSI, board.MISO)
# print("SPI ok!")

# print("done!\n")

"""
Using TinyLoRa with a Si7021 Sensor.
"""

# Board LED
led = digitalio.DigitalInOut(board.D4)
led.direction = digitalio.Direction.OUTPUT

# Create library object using our bus i2c port for si7021
i2c = busio.I2C(board.SCL, board.SDA)
sensor = adafruit_si7021.SI7021(i2c)

# Create library object using our bus SPI port for radio
spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)

# RFM9x Breakout Pinouts
# cs = digitalio.DigitalInOut(board.D5)
# irq = digitalio.DigitalInOut(board.D6)
# rst = digitalio.DigitalInOut(board.D4)


# Dragino LoRa GPS hat settings:
# Rasperry Pi 4:
# cs = digitalio.DigitalInOut(board.D25)
# irq = digitalio.DigitalInOut(board.D7)
# rst = digitalio.DigitalInOut(board.D17)

# Jetson Nano:
cs = digitalio.DigitalInOut(board.D25)
irq = digitalio.DigitalInOut(board.D8)
rst = digitalio.DigitalInOut(board.D17)

# "freq": 868100000,
# "freq_2": 868100000,
# "spread_factor": 7,

# "pin_nss": 6,
# "pin_dio0": 7,
# "pin_nss_2": 6,
# "pin_dio0_2": 7,
# "pin_rst": 3,

# "pin_led1":4,
# "pin_NetworkLED": 22,
# "pin_InternetLED": 23,
# "pin_ActivityLED_0": 21,
# "pin_ActivityLED_1": 29

# Feather M0 RFM9x Pinouts
# cs = digitalio.DigitalInOut(board.RFM9X_CS)
# irq = digitalio.DigitalInOut(board.RFM9X_D0)
# rst = digitalio.DigitalInOut(board.RFM9X_RST)

# TTN Device Address, 4 Bytes, MSB
devaddr = bytearray([0x26, 0x01, 0x13, 0x30])
# { 0x26, 0x01, 0x13, 0x30 }

# TTN Network Key, 16 Bytes, MSB
nwkey = bytearray([0x4D, 0xE2, 0x25, 0x50, 0xB5, 0x5D, 0x26, 0xE9,
                   0x34, 0x73, 0x61, 0x07, 0x5A, 0x63, 0x21, 0xA7])
# { 0x4D, 0xE2, 0x25, 0x50, 0xB5, 0x5D, 0x26, 0xE9, 0x34, 0x73, 0x61, 0x07, 0x5A, 0x63, 0x21, 0xA7 }

# TTN Application Key, 16 Bytess, MSB
app = bytearray([0x73, 0xF6, 0xE1, 0x22, 0x26, 0x0A, 0x34, 0x66,
                 0x19, 0x8E, 0x27, 0x2A, 0x81, 0xC4, 0x8B, 0xA1])
# { 0x73, 0xF6, 0xE1, 0x22, 0x26, 0x0A, 0x34, 0x66, 0x19, 0x8E, 0x27, 0x2A, 0x81, 0xC4, 0x8B, 0xA1 }

ttn_config = TTN(devaddr, nwkey, app, country='EU')

lora = TinyLoRa(spi, cs, irq, rst, ttn_config)

lora.set_datarate("SF12BW125")

# Data Packet to send to TTN
data = bytearray(8)

# while True:
temp_val = sensor.temperature
humid_val = sensor.relative_humidity
# temp_val = 12
# humid_val = 94


# time.sleep(5)

print (time.strftime("%Y-%d-%b-%H:%M"))
print('Temperature: %0.2f C' % temp_val)
print('relative humidity: %0.1f %%' % humid_val)
print('Bat species array: ', bat_species_val)
print('Bat audio events array: ', total_audio_events)
print("")
# Encode float as int
temp_val = int(temp_val * 100)
humid_val = int(humid_val * 100)



file = "/home/tegwyn/ultrasonic_classifier/helpers/species_iteration.txt"
if os.path.isfile(file):
	with open(file, "r") as fp:
		species_iteration = fp.read()
	fp.close()


# We dont just send all the bat detection data in one go, instead we iterate continuously over the no. of species.
# This overcomes the problem of data getting lost if transmission fails.
print("current species iteration = ",species_iteration)
print("total number_of species_detected = ", number_of_species_detected)

# Encode payload as bytes
data[0] = (temp_val >> 8) & 0xff
print("data 0: ",data[0])
data[1] = temp_val & 0xff
print("data 1: ",data[1])

data[2] = (humid_val >> 8) & 0xff
print("data 2: ",data[2])
data[3] = humid_val & 0xff
print("data 3: ",data[3])

data[4] = (bat_species_val[int(species_iteration)] >> 8) & 0xff
print("data 4: ",data[4])
data[5] = bat_species_val[int(species_iteration)] & 0xff
print("data 5: ",data[5])

data[6] = (total_audio_events[int(species_iteration)] >> 8) & 0xff
print("data 6: ",data[6])
data[7] = total_audio_events[int(species_iteration)] & 0xff
print("data 7: ",data[7])

if int(species_iteration) < (number_of_species_detected -1):
    species_iteration = str(int(species_iteration) +1)
else:
    species_iteration = "0"

file = "/home/tegwyn/ultrasonic_classifier/helpers/species_iteration.txt"
f= open(file, "w+")
f.write(species_iteration)
f.close()

# Send data packet
# print('Sending packet...')
sys.stderr.write(F_LightBlue+ "Sending packet..." + '\x1b[0m' + end)
lora.send_data(data, len(data), lora.frame_counter)
# print('Packet Sent!')
sys.stderr.write(RED+ str(data) + '\x1b[0m' + end)
sys.stderr.write(F_LightBlue+ "..... Packet Sent!\n" + '\x1b[0m' + end)

led.value = True
lora.frame_counter += 1
time.sleep(2)
led.value = False

