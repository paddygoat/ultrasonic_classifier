echo whales | sudo -S apt-get update -y && sudo -S apt-get upgrade -y


# https://medium.com/@RaghavPrabhu/a-simple-tutorial-to-classify-images-using-tensorflow-step-by-step-guide-7e0fad26c22

# Convert png to jpg:
cd /media/tegwyn/Xavier_SD/dog-breed-identification/build/dataset/c_pip_spectographs && ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'
cd /media/tegwyn/Xavier_SD/dog-breed-identification/build/dataset/nattereri_spectographs && ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'
cd /media/tegwyn/Xavier_SD/dog-breed-identification/build/dataset/plecotus_spectograms && ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'
cd /media/tegwyn/Xavier_SD/dog-breed-identification/build/dataset/s_pip_spectographs && ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'

ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'

# Copy imagenet folder over to tmp:
cp /media/tegwyn/Xavier_SD/dog-breed-identification/imagenet /tmp

cd /media/tegwyn/Xavier_SD/dog-breed-identification/
python3 data_processing.py

cd /media/tegwyn/Xavier_SD/dog-breed-identification/
python3 retrain.py --image_dir=build/dataset/ --bottleneck_dir=build/bottleneck/ --how_many_training_steps=10000 --output_graph=build/trained_model/retrained_graph.pb --output_lables=build/trained_model/retrained_labels.txt --summaries_dir=build/summaries


cd /media/tegwyn/Xavier_SD/dog-breed-identification/build
tensorboard --logdir=summaries/ --host=0.0.0.0 --port=8888

# To test an image, dump it in /media/tegwyn/Xavier_SD/dog-breed-identification/test, then:
# Edit this file with appropriate labels:
gedit /media/tegwyn/Xavier_SD/dog-breed-identification/build/trained_model/retrained_labels.txt

cd /media/tegwyn/Xavier_SD/dog-breed-identification/ && python3 classify.py



# mogrify -crop 5828x1179+220+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/plecotus_test_0.5_1094.png
# mogrify -crop 5500x1080+220+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/plecotus_test_0.5_1094.png
# mogrify -crop 5500x1080+220+100 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmap.png
# mogrify -crop 5500x940+220+320 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmap.png
mogrify -crop 5500x680+220+340 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmap.png

cd /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/
cp bitmaplabelled.png bitmaplabelled_1.png


# This produces image 1 of 8:
cp bitmaplabelled.png bitmaplabelled_1.png
mogrify -crop 680x680+0+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmaplabelled_1.png

# This produces image 2 of 8:
cp bitmaplabelled.png bitmaplabelled_2.png
mogrify -crop 680x680+680+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmaplabelled_2.png

# This produces image 3 of 8:
cp bitmaplabelled.png bitmaplabelled_3.png
mogrify -crop 680x680+1360+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmaplabelled_3.png

# This produces image 4 of 8:
cp bitmaplabelled.png bitmaplabelled_4.png
mogrify -crop 680x680+2040+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmaplabelled_4.png

# This produces image 5 of 8:
cp bitmaplabelled.png bitmaplabelled_5.png
mogrify -crop 680x680+2720+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmaplabelled_5.png

# This produces image 6 of 8:
cp bitmaplabelled.png bitmaplabelled_6.png
mogrify -crop 680x680+3400+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmaplabelled_6.png

# This produces image 7 of 8:
cp bitmaplabelled.png bitmaplabelled_7.png
mogrify -crop 680x680+4080+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmaplabelled_7.png

# This produces image 8 of 8:
cp bitmaplabelled.png bitmaplabelled_8.png
mogrify -crop 680x680+4760+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmaplabelled_8.png

###################################################################################################################################

cd /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs && ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'

cd /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/


# This produces image 1 of 8:
cp bitmap.jpg bitmap_1.jpg
mogrify -crop 680x680+0+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmap_1.jpg

# This produces image 2 of 8:
cp bitmap.jpg bitmap_2.jpg
mogrify -crop 680x680+680+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmap_2.jpg

# This produces image 3 of 8:
cp bitmap.jpg bitmap_3.jpg
mogrify -crop 680x680+1360+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmap_3.jpg

# This produces image 4 of 8:
cp bitmap.jpg bitmap_4.jpg
mogrify -crop 680x680+2040+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmap_4.jpg

# This produces image 5 of 8:
cp bitmap.jpg bitmap_5.jpg
mogrify -crop 680x680+2720+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmap_5.jpg

# This produces image 6 of 8:
cp bitmap.jpg bitmap_6.jpg
mogrify -crop 680x680+3400+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmap_6.jpg

# This produces image 7 of 8:
cp bitmap.jpg bitmap_7.jpg
mogrify -crop 680x680+4080+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmap_7.jpg

# This produces image 8 of 8:
cp bitmap.jpg bitmap_8.jpg
mogrify -crop 680x680+4760+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/bitmap_8.jpg

############################################################################################################################

cd /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/

name=bitmap

# This produces image 1 of 8:
cp "$name".jpg "$name"_1.jpg
mogrify -crop 680x680+0+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/"$name"_1.jpg

# This produces image 2 of 8:
cp "$name".jpg "$name"_2.jpg
mogrify -crop 680x680+680+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/"$name"_2.jpg

# This produces image 3 of 8:
cp "$name".jpg "$name"_3.jpg
mogrify -crop 680x680+1360+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/"$name"_3.jpg

# This produces image 4 of 8:
cp "$name".jpg "$name"_4.jpg
mogrify -crop 680x680+2040+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/"$name"_4.jpg

# This produces image 5 of 8:
cp "$name".jpg "$name"_5.jpg
mogrify -crop 680x680+2720+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/"$name"_5.jpg

# This produces image 6 of 8:
cp "$name".jpg "$name"_6.jpg
mogrify -crop 680x680+3400+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/"$name"_6.jpg

# This produces image 7 of 8:
cp "$name".jpg "$name"_7.jpg
mogrify -crop 680x680+4080+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/"$name"_7.jpg

# This produces image 8 of 8:
cp "$name".jpg "$name"_8.jpg
mogrify -crop 680x680+4760+0 /media/tegwyn/Xavier_SD/dog-breed-identification/build/plecotus_test_spectographs/"$name"_8.jpg





