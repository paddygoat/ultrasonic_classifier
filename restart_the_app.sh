#!/bin/bash
# cd /home/tegwyn/ultrasonic_classifier/ && bash restart_the_app.sh

# This script is called from GUI.py.

RED='\e[41m'
BLUE='\e[44m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BLINK='\e[5m'

printf "From restart_the _app.sh: ${RED}Trying to kill the GUI: .....${NC}\n"
cd /home/tegwyn/ultrasonic_classifier/helpers/
touch restart.txt
# sleep 2
# killall -9 -w python  This does not work for Jetson Nano !!
killall -9 -w python3
killall -9 -w python
# sh ./run.sh      # What is this for?

exit



# The -g option tells killall to terminate the entire process group to which the specified process belongs.
# The -l option tells killall to list all known signal names. 
# $ killall -l
# HUP INT QUIT ILL TRAP ABRT BUS FPE KILL USR1 SEGV USR2 PIPE ALRM TERM STKFLT
# CHLD CONT STOP TSTP TTIN TTOU URG XCPU XFSZ VTALRM PROF WINCH POLL PWR SYS

# The -w option tells killall to wait for all designated processes to die.
# killall's basic syntax is:  killall [options] program_name(s)

# killall -9 bash
# pkill -9 app

# How to kill processes older than TIME
# Want to kill a process called vim that has been running for more than 24 hours? Try:
# killall -o 24h appName
# killall -o 24h vim

# s	seconds
# m	minutes
# h	hours
