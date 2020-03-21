#!/bin/bash
# cd /home/tegwyn/ultrasonic_classifier/ && bash modem.sh

RED='\e[41m'
BLUE='\e[44m'
GREEN='\033[0;32m'
CYAN='\e[36m'
MAGENTA='\e[45m'
GREY='\e[100m'
YELLOW='\e[93m'

NC='\033[0m' # No Color
BLINK='\e[5m'


printf "${GREY} ${BLINK} Modem ${NC}\n"

# This is the only GPS command that seems to work:
# echo whales | sudo -S mmcli -m 0 --location-get /org/freedesktop/ModemManager1/Modem/0

# echo whales | sudo -S mmcli -m 0 --location-get-gps-raw /org/freedesktop/ModemManager1/Modem/0
# echo whales | sudo -S mmcli -m 0 --location-enable-gps-nmea /org/freedesktop/ModemManager1/Modem/0
# sleep 5

# Need to wait a while before next command.
# echo whales | sudo -S mmcli -m 0 --location-status

# sleep 5
# Need to wait a while before next command.
# echo whales | sudo -S mmcli -m 0 --location-get-gps-nmea /org/freedesktop/ModemManager1/Modem/0

# sleep 5
# echo whales | sudo -S mmcli -m 0 --location-get-gps-raw /org/freedesktop/ModemManager1/Modem/0

# This will disable modem. Modem manager will then turn it on again if auto connect is enabled.
echo whales | sudo -S mmcli -m 0 -d

printf "${GREY} Modem turned off ... will modem manager turn it on again? ${NC}\n"

exit

