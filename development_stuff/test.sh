#!/bin/bash
# cd /home/tegwyn/ultrasonic_classifier/ && bash test.sh
# sudo chmod u+x test.sh


RED='\e[41m'
BLUE='\e[44m'
GREEN='\033[0;32m'
CYAN='\e[36m'
MAGENTA='\e[45m'
GREY='\e[100m'
YELLOW='\e[93m'

NC='\033[0m' # No Color
BLINK='\e[5m'

printf "${RED}${BLINK}Hello !!!!!${NC}\n"

# ps -C R >/dev/null && echo "R Running OK" || echo "R Not running"
# ps -C geany >/dev/null && echo "geany Running OK" || echo "geany Not running"

SERVICE="geany"
if pgrep -x "$SERVICE" >/dev/null
then
  echo "$SERVICE is running"
else
  echo "$SERVICE stopped"
fi

SERVICE="R"
if pgrep -x "$SERVICE" >/dev/null
then
  printf "${GREY}${SERVICE} is running ${NC}\n"
else
  printf "${GREY}${SERVICE} stopped ${NC}\n"
fi
