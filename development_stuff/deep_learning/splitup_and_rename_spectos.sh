#!/bin/bash
# $ cd /home/tegwyn/ultrasonic_classifier/development_stuff/ && bash splitup_and_rename_spectos.sh

RED='\e[41m'
BLUE='\e[44m'
GREEN='\033[0;32m'
CYAN='\e[36m'
MAGENTA='\e[45m'
GREY='\e[100m'
YELLOW='\e[93m'

NC='\033[0m' # No Color
BLINK='\e[5m'

# Files to process should be .pg of 5828 pixels wide by 1179 high.

# cd /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/test/
cd /home/tegwyn/ultrasonic_classifier/images/test/
# cd /home/tegwyn/ultrasonic_classifier/images/rhino_hippo_spectographs/


# Convert all .png files to .jpg or else mogrify wont work properly:
printf "${GREEN}Converting .png to .jpg .....${NC}\n"
ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'
# delete the .png files:
find . -maxdepth 1 -type f -iname \*.png -delete


# Now split up all the 0.5 second long files into 8 parts of 680 pixels each:
for file in *
do
    fname="${file%.*}"
    # fname=noctula_0.5_1847
    printf "${GREEN}Processing file: ${fname} ${NC}\n"
    
    mogrify -crop 5500x680+220+340 "$fname".jpg
    # mogrify -crop 5500x680+220+340 c_pip_0.5_1678.jpg
    
    i=1

	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+0+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+680+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1360+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2040+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+2720+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3400+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4080+0 "$fname"_"$i"_7.jpg
	# This produces image 8 of 8:
	cp "$fname".jpg "$fname"_"$i"_8.jpg
	mogrify -crop 680x680+4760+0 "$fname"_"$i"_8.jpg

    i=2
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+100+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+780+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1460+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2140+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+2820+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3500+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4180+0 "$fname"_"$i"_7.jpg

    i=3
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+200+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+880+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1560+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2240+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+2920+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3600+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4280+0 "$fname"_"$i"_7.jpg
	
    i=4
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+300+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+980+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1660+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2340+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+3020+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3700+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4380+0 "$fname"_"$i"_7.jpg
    
    i=5
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+400+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+1080+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1760+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2440+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+3120+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3800+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4480+0 "$fname"_"$i"_7.jpg
	
    i=6
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+500+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+1180+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1860+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2540+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+3220+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3900+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4580+0 "$fname"_"$i"_7.jpg
	
    i=7
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+600+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+1280+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1960+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2640+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+3320+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+4000+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4680+0 "$fname"_"$i"_7.jpg
	
done

printf "${GREEN}Finished! ${NC}\n"

exit









