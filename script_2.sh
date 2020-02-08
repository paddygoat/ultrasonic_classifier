#!/bin/bash
# cd /home/tegwyn/ultrasonic_classifier/ && chmod 775 script_2.sh

RED='\e[41m'
BLUE='\e[44m'
GREEN='\033[0;32m'
CYAN='\e[36m'
MAGENTA='\e[45m'
GREY='\e[100m'
YELLOW='\e[93m'

NC='\033[0m' # No Color
BLINK='\e[5m'

cd /home/tegwyn/ultrasonic_classifier/
printf "${BLUE}Now assigning an R script ...... ${NC}\n"

file='/home/tegwyn/ultrasonic_classifier/helpers/combo_01.txt'

line=1
result=$(head -n $line /home/tegwyn/ultrasonic_classifier/helpers/combo_01.txt | tail -1)
# echo $result

line=1
result=$(head -n $line /home/tegwyn/ultrasonic_classifier/helpers/combo_01.txt | tail -1)
# echo $result

if [ ${result} = "UK_Bats" ]; then
  echo "UK_Bats was selected"
elif [ ${result} = "Rodents" ]; then
  echo "Rodents was selected"
elif [ ${result} = "Mechanical_Bearings" ]; then
  echo "Mechanical_Bearings was selected"
fi
choice1=$result

line=2
result=$(head -n $line /home/tegwyn/ultrasonic_classifier/helpers/combo_01.txt | tail -1)
# echo $result

if [ ${result} = "Level1:_Species" ]; then
  echo "Level1:_Species was selected"
elif [ ${result} = "Level2:_Genera" ]; then
  echo "Level2:_Genera was selected"
elif [ ${result} = "Level3:_Order" ]; then
  echo "Level3:_Order was selected"
elif [ ${result} = "Bicycle_Wheel" ]; then
  echo "Bicycle_Wheel was selected"
fi
choice2=$result

line=3
result=$(head -n $line /home/tegwyn/ultrasonic_classifier/helpers/combo_01.txt | tail -1)
# echo $result

if [ ${result} = "All_Calls" ]; then
  echo "All_Calls was selected"
elif [ ${result} = "Echolocation_Only" ]; then
  echo "Echolocation was selected"
elif [ ${result} = "Socials_Only" ]; then
  echo "Socials was selected"
elif [ ${result} = "NULL" ]; then
  echo "NULL was selected"
fi
choice3=$result

# This is where the R classifier is deployed:
if [ ${choice1} = "UK_Bats" ] && [ ${choice2} = "Level1:_Species" ]; then
  Rscript deploy_classifier_async_01.R
  echo "Level 1 was deployed"
elif [ ${choice1} = "UK_Bats" ] && [ ${choice2} = "Level2:_Genera" ]; then
  Rscript Deploy_bats_pi_Level2.R
  echo "Level 2 was deployed"
elif [ ${choice1} = "UK_Bats" ] && [ ${choice2} = "Level3:_Order" ]; then
  Rscript Deploy_bats_pi_Level3.R
  echo "Level 3 was deployed"
else
  echo "No valid combo box selection was made, or spectogram was selected"
  sleep 5
fi

printf "${BLUE}Iteration ${iter} classifier has finished! ${NC}\n"





