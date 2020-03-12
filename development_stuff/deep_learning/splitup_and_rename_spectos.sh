#!/bin/bash
# 50 pixel sliding window.
# All audio files need to be 384 kb/s sample rate.
# Matplotlib settings: figure.figsize = [24,10],NFFT = 1024, noverlap = 1018, dpi = 300.
# Specto image size will then be exactly 5828 x 1179.

# cd /home/tegwyn/ultrasonic_classifier/development_stuff/deep_learning/ && bash splitup_and_rename_spectos.sh
# Images to process should be in /home/tegwyn/ultrasonic_classifier/images/test/

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
	mogrify -crop 680x680+50+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+730+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1410+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2090+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+2770+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3450+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4130+0 "$fname"_"$i"_7.jpg
	# This produces image 8 of 8:
	cp "$fname".jpg "$fname"_"$i"_8.jpg
	mogrify -crop 680x680+4810+0 "$fname"_"$i"_8.jpg

    i=3
    
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
	
    i=4
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+150+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+830+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1510+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2190+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+2870+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3550+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4230+0 "$fname"_"$i"_7.jpg

    i=5
    
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
	
    i=6
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+250+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+930+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1610+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2290+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+2970+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3650+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4330+0 "$fname"_"$i"_7.jpg
	
    i=7
    
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
	
    i=8
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+350+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+1030+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1710+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2390+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+3070+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3750+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4430+0 "$fname"_"$i"_7.jpg
    
    i=9
    
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
	
    i=10
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+450+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+1130+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1810+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2490+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+3170+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3850+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4530+0 "$fname"_"$i"_7.jpg
	
    i=11
    
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
	
    i=12
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+550+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+1230+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+1910+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2590+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+3270+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+3950+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4630+0 "$fname"_"$i"_7.jpg
	
    i=13
    
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
	
    i=14
    
	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_"$i"_1.jpg
	mogrify -crop 680x680+650+0 "$fname"_"$i"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_"$i"_2.jpg
	mogrify -crop 680x680+1330+0 "$fname"_"$i"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_"$i"_3.jpg
	mogrify -crop 680x680+2010+0 "$fname"_"$i"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_"$i"_4.jpg
	mogrify -crop 680x680+2690+0 "$fname"_"$i"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_"$i"_5.jpg
	mogrify -crop 680x680+3370+0 "$fname"_"$i"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_"$i"_6.jpg
	mogrify -crop 680x680+4050+0 "$fname"_"$i"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_"$i"_7.jpg
	mogrify -crop 680x680+4730+0 "$fname"_"$i"_7.jpg
	
done

printf "${GREEN}Finished! ${NC}\n"

exit









