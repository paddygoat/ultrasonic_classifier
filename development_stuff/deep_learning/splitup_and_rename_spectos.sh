#!/bin/bash
# $ cd /media/tegwyn/Xavier_SD/dog-breed-identification/ && bash splitup_and_rename_spectos.sh


# Files to process should be .pg of 5828 pixels wide by 1179 high.

cd /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/test/

# Convert all .png files to .jpg or else mogrify wont work properly:
ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'
# delete the .png files:
find . -maxdepth 1 -type f -iname \*.png -delete

# Now split up all the 0.5 second long files into 8 parts of 680 pixels each:
for file in *
do
    fname="${file%.*}"
    
    mogrify -crop 5500x680+220+340 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/test/"$fname".jpg

	# This produces image 1 of 8:
	cp "$fname".jpg "$fname"_1.jpg
	mogrify -crop 680x680+0+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/test/"$fname"_1.jpg
	# This produces image 2 of 8:
	cp "$fname".jpg "$fname"_2.jpg
	mogrify -crop 680x680+680+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/test/"$fname"_2.jpg
	# This produces image 3 of 8:
	cp "$fname".jpg "$fname"_3.jpg
	mogrify -crop 680x680+1360+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/test/"$fname"_3.jpg
	# This produces image 4 of 8:
	cp "$fname".jpg "$fname"_4.jpg
	mogrify -crop 680x680+2040+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/test/"$fname"_4.jpg
	# This produces image 5 of 8:
	cp "$fname".jpg "$fname"_5.jpg
	mogrify -crop 680x680+2720+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/test/"$fname"_5.jpg
	# This produces image 6 of 8:
	cp "$fname".jpg "$fname"_6.jpg
	mogrify -crop 680x680+3400+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/test/"$fname"_6.jpg
	# This produces image 7 of 8:
	cp "$fname".jpg "$fname"_7.jpg
	mogrify -crop 680x680+4080+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/test/"$fname"_7.jpg
	# This produces image 8 of 8:
	cp "$fname".jpg "$fname"_8.jpg
	mogrify -crop 680x680+4760+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/test/"$fname"_8.jpg

    i=$((i+1))
    
done

exit


# Convert all .png files to .jpg or else mogrify wont work properly:
ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'
# delete the .png files:
find . -maxdepth 1 -type f -iname \*.png -delete



exit

for file in *
do
    # separate the file name from its extension
    if [[ $file == *.png ]]; then


    fi
done








