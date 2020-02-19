#!/usr/bin/python

# cd /home/tegwyn/ultrasonic_classifier/ && sudo python3 test.py
# cd /home/tegwyn/ultrasonic_classifier/ && chmod 775 test.py


import time
import busio
import digitalio
import board
import adafruit_si7021
from adafruit_tinylora.adafruit_tinylora import TTN, TinyLoRa

print("Hello blinka!")

# Try to great a Digital input
pin = digitalio.DigitalInOut(board.D4)
print("Digital IO ok!")

# Try to create an I2C device
i2c = busio.I2C(board.SCL, board.SDA)
print("I2C ok!")

# Try to create an SPI device
spi = busio.SPI(board.SCLK, board.MOSI, board.MISO)
print("SPI ok!")

print("done!")

"""Using TinyLoRa with a Si7021 Sensor.
"""

# Board LED
led = digitalio.DigitalInOut(board.D13)
led.direction = digitalio.Direction.OUTPUT

# Create library object using our bus i2c port for si7021
# i2c = busio.I2C(board.SCL, board.SDA)
# sensor = adafruit_si7021.SI7021(i2c)

# Create library object using our bus SPI port for radio
spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)

# RFM9x Breakout Pinouts
# cs = digitalio.DigitalInOut(board.D5)
# irq = digitalio.DigitalInOut(board.D6)
# rst = digitalio.DigitalInOut(board.D4)

cs = digitalio.DigitalInOut(board.D25)
irq = digitalio.DigitalInOut(board.D7)
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

# Data Packet to send to TTN
data = bytearray(4)

while True:
    # temp_val = sensor.temperature
    # humid_val = sensor.relative_humidity
    temp_val = 17
    humid_val = 96
    print('Temperature: %0.2f C' % temp_val)
    print('relative humidity: %0.1f %%' % humid_val)

    # Encode float as int
    # temp_val = int(temp_val * 100)
    # humid_val = int(humid_val * 100)
    temp_val = 17
    humid_val = 97

    # Encode payload as bytes
    data[0] = (temp_val >> 8) & 0xff
    data[1] = temp_val & 0xff
    data[2] = (humid_val >> 8) & 0xff
    data[3] = humid_val & 0xff

    # Send data packet
    print('Sending packet...')
    lora.send_data(data, len(data), lora.frame_counter)
    print('Packet Sent!')
    led.value = True
    lora.frame_counter += 1
    time.sleep(2)
    led.value = False

