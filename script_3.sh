#!/bin/bash
# cd /home/tegwyn/ultrasonic_classifier/ && bash script_3.sh
# cd /home/tegwyn/ultrasonic_classifier/ && chmod 775 script_3.sh

RED='\e[41m'
BLUE='\e[44m'
GREEN='\033[0;32m'
CYAN='\e[36m'
MAGENTA='\e[45m'
GREY='\e[100m'
YELLOW='\e[93m'

NC='\033[0m' # No Color
BLINK='\e[5m'

# /opt/vc/bin/vcgencmd measure_temp
# echo $(($(date +%s%N)/1000000))
printf "${MAGENTA} ${BLINK} script_3.sh has started ${NC}\n"

cd /home/tegwyn/ultrasonic_classifier/

# The below reads the Final_result text file and renames the new_${iter}.wav to the bat name and time of detection and confidence.

# The value of FILE is set via 'export' in script_1.sh, line 55. Currently it is: /home/tegwyn/ultrasonic_classifier/Final_result.txt

if [ -f "$FILE" ]; then
  bat_detected=1
  cd /home/tegwyn/ultrasonic_classifier/

  exec 6< Final_result.txt
  read line1 <&6
  read line2 <&6
  read line3 <&6
  read line4 <&6
  read line5 <&6
  read line6 <&6
  read line7 <&6

  printf "${GREEN} $line2 ${NC}\n"
  batName=$(echo "$line2" | sed 's|[.",]||g')                                # remove some " characters
  printf "${GREEN} $batName ${NC}\n"
  batName=$(printf '%s' "$batName" | sed 's/[0-9]//g')                       # remove digits
  batName=$(printf '%s' "$batName" | sed 's/ //g')                           # remove white spaces.
  batName=$(printf '%s' "$batName" | sed 's/[[:blank:]]//g')                 # remove tab spaces.

  batConfidence=$(echo "$line2" | sed 's/.*[[:blank:]]//') 
  # batConfidence2=$((10*$batConfidence))

  # batConfidence2=$(echo "scale=2; 100 * $batConfidence" | bc -l)
  batConfidence2=$(echo "scale=2; (100 * $batConfidence)+2" | bc -l)
  batConfidence3=$(echo "$batConfidence2" | sed 's/[.].*$//')

  # printf "${GREEN}Bat confidence2 value is: $batConfidence2 ${NC}\n"
  printf "${GREEN}Bat confidence3 value is: $batConfidence3 ${NC}\n"

  printf "${GREEN}Bat detected was a $batName ${NC}\n"
  echo $batName > '/home/tegwyn/ultrasonic_classifier/helpers/status_update.txt'
  exec 6<&-

  cd /home/tegwyn/ultrasonic_classifier/temp/

  newName=$(date +%d-%m-%Y_%H:%M:%S)
  cp $FILE /home/tegwyn/ultrasonic_classifier/Final_result_copy.txt

  newName2="${batConfidence3}p_${batName}_${newName}"                # 'p' stands for percent. Cant use percent character as causes problems down the line.
  # printf "${GREEN}New name:  ${newName2} ${NC}\n"

#################################################################################################################
  printf "\n"
  printf "${GREEN}First bat: ${NC}\n"
  batName2=$(echo "$line2" | sed 's|[",]||g')                                     # remove some " characters
  batName2=$(printf '%s' "$batName2" | sed 's/\(\.[0-9][0-9][0-9]\)[0-9]*/\1/g')  # remove all numbers 2 spaces after decimal point.
  batName2=$(printf '%s' "$batName2" | sed -r 's/[[:space:]]+/<td>/g')            # replace white spaces with html <td>.
  printf "${GREEN} $batName2 ${NC}\n"
#################################################################################################################
  printf "${GREEN}Second bat: ${NC}\n"
  batName3=$(echo "$line3" | sed 's|[",]||g')                                     # remove some " characters
  batName3=$(printf '%s' "$batName3" | sed 's/\(\.[0-9][0-9][0-9]\)[0-9]*/\1/g')  # remove all numbers 2 spaces after decimal point.
  batName3=$(printf '%s' "$batName3" | sed -r 's/[[:space:]]+/<td>/g')            # replace white spaces with html <td>.
  printf "${GREEN} $batName3 ${NC}\n"
##################################################################################################################
  printf "${GREEN}Third bat: ${NC}\n"
  batName4=$(echo "$line4" | sed 's|[",]||g')                                     # remove some " characters
  batName4=$(printf '%s' "$batName4" | sed 's/\(\.[0-9][0-9][0-9]\)[0-9]*/\1/g')  # remove all numbers 2 spaces after decimal point.
  batName4=$(printf '%s' "$batName4" | sed -r 's/[[:space:]]+/<td>/g')            # replace white spaces with html <td>.
  printf "${GREEN} $batName4 ${NC}\n"
##################################################################################################################
  printf "${GREEN}Fourth bat: ${NC}\n"
  batName5=$(echo "$line5" | sed 's|[",]||g')                                     # remove some " characters
  batName5=$(printf '%s' "$batName5" | sed 's/\(\.[0-9][0-9][0-9]\)[0-9]*/\1/g')  # remove all numbers 2 spaces after decimal point.
  batName5=$(printf '%s' "$batName5" | sed -r 's/[[:space:]]+/<td>/g')            # replace white spaces with html <td>.
  printf "${GREEN} $batName5 ${NC}\n"
##################################################################################################################
  printf "${GREEN}Fifth bat: ${NC}\n"
  batName6=$(echo "$line6" | sed 's|[",]||g')                                     # remove some " characters
  batName6=$(printf '%s' "$batName6" | sed 's/\(\.[0-9][0-9][0-9]\)[0-9]*/\1/g')  # remove all numbers 2 spaces after decimal point.
  batName6=$(printf '%s' "$batName6" | sed -r 's/[[:space:]]+/<td>/g')            # replace white spaces with html <td>.
  printf "${GREEN} $batName6 ${NC}\n"
##################################################################################################################
  printf "${GREEN}Sixth bat: ${NC}\n"
  batName7=$(echo "$line7" | sed 's|[",]||g')                                     # remove some " characters
  batName7=$(printf '%s' "$batName7" | sed 's/\(\.[0-9][0-9][0-9]\)[0-9]*/\1/g')  # remove all numbers 2 spaces after decimal point.
  batName7=$(printf '%s' "$batName7" | sed -r 's/[[:space:]]+/<td>/g')            # replace white spaces with html <td>.
  printf "${GREEN} $batName7 ${NC}\n"
  printf "\n"
#################################################################################################################
  mv filtered.wav ${newName2}.wav                                            # Create the new wav file with new informative name.
  # cp $FILE /home/tegwyn/ultrasonic_classifier/results/${newName2}.txt        # Create the text file with new informative name.
#################################################################################################################


  cp ${newName2}.wav /home/tegwyn/ultrasonic_classifier/detected_bat_audio/     # Copy the newly named wav file to detected bat audio folder.
  rm ${newName2}.wav
  printf "${GREEN}Success: A ${batName} bat classification result was published for iteration no. ${iter}! ${NC}\n"

else
  printf "${GREEN}No classification result was published for iteration no. ${iter}! ${NC}\n"
  bat_detected=0
  batConfidence3=0
fi

conf=50

f_alert_sounds ()
{
if [ $batConfidence3 -gt $conf ]; then
  if [ ${batName} = "HOUSE_KEYS" ]; then
    aplay --device=hw:0,3 /home/tegwyn/ultrasonic_classifier/alert_sounds/keys.wav
  elif [ ${batName} = "NOCTULA" ]; then
    aplay --device=hw:0,3 /home/tegwyn/ultrasonic_classifier/alert_sounds/noctule.wav
  elif [ ${batName} = "NATTERERI" ]; then
    aplay --device=hw:0,3 /home/tegwyn/ultrasonic_classifier/alert_sounds/nattereri.wav
  elif [ ${batName} = "PLECOTUS" ]; then
    aplay --device=hw:0,3 /home/tegwyn/ultrasonic_classifier/alert_sounds/plecotus.wav
  elif [ ${batName} = "NATTERERI" ]; then
    aplay --device=hw:0,3 /home/tegwyn/ultrasonic_classifier/alert_sounds/nattereri.wav
  elif [ ${batName} = "C_PIP" ]; then
    aplay --device=hw:0,3 /home/tegwyn/ultrasonic_classifier/alert_sounds/c_pip.wav
  elif [ ${batName} = "S_PIP" ]; then
    aplay --device=hw:0,3 /home/tegwyn/ultrasonic_classifier/alert_sounds/s_pip.wav
  fi
fi
}

# printf "${GREEN}Is there still a  ./script_2.sh: 79: [: -gt: unexpected operator error? ${NC}\n"
directory_to_search_inside="/home/tegwyn/ultrasonic_classifier/detected_bat_audio"
file_count=$( set -- $directory_to_search_inside/* ; echo $#)
# printf "$file_count \n"
# printf "${GREEN}File count in detected_bat_audio directory: $file_count  ${NC}\n"

if [ $bat_detected -gt 0 ]; then
  # printf "${GREEN}Bat_detected value: ${bat_detected} ${NC}\n"
  cd /home/tegwyn/ultrasonic_classifier/temp/
  ls -t | tail -n +4 | xargs rm                   # Delete all files except for the three newest.
  # printf "${GREEN}Was there an rm missing operand error? deleting from temp ${NC}\n"
  if  [ $file_count -gt 500 ]; then
    cd /home/tegwyn/ultrasonic_classifier/detected_bat_audio/
    ls|sort -V -r | tail -n +500 | xargs rm         # Delete all files except for the best 500.
    # printf "${GREEN}Was there an rm missing operand error? deleting from detected_bats${NC}\n"
    # TODO above error is probably caused by rm not finding the prescribed files ie there are less than 500 files in the detected_bat_audio directory.
  fi
fi

cd /home/tegwyn/ultrasonic_classifier/
# sleep 10
printf "${MAGENTA} ${BLINK} script_3.sh has finished ${NC}\n"

#################################################################################################################

  exec > /home/tegwyn/ultrasonic_classifier/results/${newName2}.html        # Create the html file with new informative name.
  printf '<html>'
  printf '<head>'
  printf '<link REL="SHORTCUT ICON" HREF="http://www.goatindustries.co.uk/goat.ico">'
  printf '<title>Intelligent Bat Detector - Audio files saved</title>'
  printf '</head>'
  printf '<body>\n'
  printf '<a href="http://www.goatindustries.co.uk/bat_detector/showdata.php"><button>Back to Main Page</button></a>'
  printf '<a href="http://www.goatindustries.co.uk/bat_detector/saved_audio_files.html"><button>Back to Saved Audio Page</button></a>'
  printf '<table width="580" border="1">\n'
  printf '<tr><td></td><td>NO</td><td>YES</td></tr>'
  printf '<tr>'
  printf '<td>'$batName2'\n'
  printf '</tr>'
  printf '<td>'$batName3'\n'
  printf '</tr>'
  printf '<td>'$batName4'\n'
  printf '</tr>'
  printf '<td>'$batName5'\n'
  printf '</tr>'
  printf '<td>'$batName6'\n'
  printf '</tr>'
  printf '<td>'$batName7'\n'
  printf '</tr>'
  printf '</table>\n'
  printf '</body>\n'
  printf '</html>'

#################################################################################################################



# sleep 10

exit
