#!/bin/bash

# To run this script, type following line into command line:
# cd /home/tegwyn/ultrasonic_classifier/ && bash record_and_filter.sh
# cd /home/tegwyn/ultrasonic_classifier/ && chmod 775 record_and_filter.sh

RED='\e[41m'
BLUE='\e[44m'
GREEN='\033[0;32m'
CYAN='\e[36m'
MAGENTA='\e[45m'
GREY='\e[100m'
YELLOW='\e[93m'

NC='\033[0m' # No Color
BLINK='\e[5m'

counter=0

f_create_filtered_wav_file ()
{
  echo "\n script record_and_filter reports: ... Now creating filtered.wav file ..... "
  cd /home/tegwyn/ultrasonic_classifier/temp/
  sox new.wav filtered.wav highpass 1k # highpass 15k highpass 15k highpass 15k highpass 15k highpass 15k highpass 15k 
  cp filtered.wav /home/tegwyn/ultrasonic_classifier/unknown_bat_audio/
  
  # Now tell the other programs that the filter.wav is ready for classification:
  touch /home/tegwyn/ultrasonic_classifier/helpers/filtered_wav_ready.txt
}
f_check_that_R_is_alive ()
{
  SERVICE="R"
  if pgrep -x "$SERVICE" >/dev/null
  then
    printf "\n${GREY}${SERVICE} is running ${NC}\n"
  else
    printf "\n${GREY}${SERVICE} stopped ${NC}\n"
    sh ./script_2.sh &                                                # Start the R scrpt again.
  fi
}



f_send_data_via_lora ()
{
	printf "\n${GREY}${SERVICE} Now send data via LoRa or FTP....... ${NC}\n"
	echo "Now send data via LoRa or FTP ..." > '/home/tegwyn/ultrasonic_classifier/helpers/status_update.txt'
	cd /home/tegwyn/ultrasonic_classifier/IOT_stuff/html/ && bash list_to_html.sh
	cd /home/tegwyn/ultrasonic_classifier/
	# echo whales | sudo -S python3 lora_sender.py
	cd /home/tegwyn/ultrasonic_classifier/
	echo whales | sudo -S python3 FTP_upload.py

	printf "\n${GREY}${SERVICE} ...... LoRa or FTP data sent !!! ${NC}\n"
}


cd /home/tegwyn/ultrasonic_classifier/

chunk_time=`cat /home/tegwyn/ultrasonic_classifier/helpers/chunk_size_record.txt` 
# printf "${GREY}Update record audio chunk size in seconds = ${chunk_time}${NC}\n"

while [ -e "$1/home/tegwyn/ultrasonic_classifier/helpers/start.txt" ]; do 
	
	counter=$((counter + 1))
	rm /home/tegwyn/ultrasonic_classifier/helpers/classification_finished.txt
    cd /home/tegwyn/ultrasonic_classifier/

    printf "${GREEN}${BLINK}\n record_and_filter.sh  reports: Now recording iteration ${counter} audio: ${NC}"
    printf "${GREEN}\n record_and_filter.sh: chunk_time: ${chunk_time} ${NC}"
    arecord -f S16 -r 384000 -d ${chunk_time} -c 1 --device=plughw:r0,0 /home/tegwyn/ultrasonic_classifier/temp/new.wav &
#################################################
    wait
#################################################
    printf "${GREEN}${BLINK}\n record_and_filter.sh reports: iteration ${counter} finished !!!! ${NC}"
    f_create_filtered_wav_file &
    f_check_that_R_is_alive &
    chunk_time=`cat /home/tegwyn/ultrasonic_classifier/helpers/chunk_size_record.txt`           # Update record audio chunk size in seconds
    # printf "${GREY}Update record audio chunk size in seconds = ${chunk_time}${NC}\n"
    printf "${GREY}Counter = ${counter}${NC}\n"

    if [ "$counter" -eq 6 ]; then
      f_send_data_via_lora &
      counter=0
    fi
done



