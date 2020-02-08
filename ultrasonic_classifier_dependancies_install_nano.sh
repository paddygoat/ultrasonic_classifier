#!/bin/bash

# Firstly:
# manually download bzip2-1.0.6 from soundforge website:
# https://sourceforge.net/projects/bzip2/files/latest/download
# It should now be in the downloads folder.

# To run this script, type following line into command line:
# cd /home/tegwyn/ultrasonic_classifier/ && bash ultrasonic_classifier_dependancies_install_nano.sh


RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

printf "${GREEN}Here we go ..... Fingers crossed! ${NC}\n"

sudo apt-get update
sudo apt-get upgrade -y

printf "${GREEN}Update and upgrade done! ${NC}\n"

# If necessary, check the version of bzip is as below:
cd && cd /home/tegwyn/Downloads/
tar zxvf bzip2-1.0.6.tar.gz 
cd bzip2-1.0.6
sudo make install

printf "${GREEN}bzip2 installed! ${NC}\n"

sudo apt-get install libncurses5-dev libncursesw5-dev
wget ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.1.7.tar.bz2
tar xvjf alsa-utils-1.1.7.tar.bz2
cd alsa-utils-1.1.7
./configure
make && sudo make install

printf "${GREEN}Alsa installed! ${NC}\n"


sudo apt-get -y install python3-pip
sudo apt-get install liblzma-dev -y
sudo apt-get install cmake -y
sudo apt-get install sox libsox-fmt-all -y
sudo apt-get install audacity -y
sudo apt-get install geany geany-plugins-common -y
sudo apt-get install bc -y
sudo apt-get install build-essential libgtk-3-dev -y
sudo pip3 install jupyter
sudo apt install python3-cairo -y
sudo apt install libcairo2 -y

pip3 install cython
pip3 install playsound
sudo apt-get install -y gir1.2-appindicator3-0.1 -y
#sudo apt-get install libasound-dev
#sudo apt-get install portaudio19-dev
#pip3 install pyaudio
#sudo apt-get install python3-pyaudio
#sudo apt-get install parallel
#pip3 install pyAudioAnalysis
pip3 install pydub
pip3 install pathlib2

sudo apt-get install python-dev libatlas-base-dev -y
pip3 install numpy
pip3 install matplotlib
pip3 install DateTimeRange
pip3 install pandas
pip3 install colorama

# pip3 install py2exe
# pip3 install timerange
#sudo pip3 install --upgrade matplotlib

# curl -O https://www.omzlo.com/downloads/pivoyager.tar.gz
# tar xvf pivoyager.tar.gz
# sudo mv pivoyager /usr/local/bin/

sudo apt install -y python3-scipy
#pip3 install scipy

# pip3 install sklearn
# pip3 install hmmlearn
# pip3 install simplejson
# pip3 install eyed3
# The script eyeD3 is installed in '/home/pi/.local/bin' which is not on PATH.
# pip3 install psrecord
# bash <(curl -Ss https://my-netdata.io/kickstart.sh)

sudo apt-get install -y gfortran libreadline6-dev libx11-dev libxt-dev libpng-dev libjpeg-dev libcairo2-dev xvfb libcurl4-openssl-dev texinfo

printf "${GREEN}Start to install R! ${NC}\n"

cd /home/tegwyn/
mkdir R_HOME
cd R_HOME
wget http://cran.rstudio.com/src/base/R-3/R-3.6.1.tar.gz
tar zxvf R-3.6.1.tar.gz 
cd && cd R_HOME/R-3.6.1/
./configure --enable-R-shlib #--with-blas --with-lapack #optional
make
sudo make install

R --version

printf "${GREEN}R 3.6.1 installed! ${NC}\n"

sudo chmod -R 777 /usr/local/lib/R/library
sudo chmod -R 777 /usr/local/lib/R/
sudo chmod -R 777 /home/tegwyn/ultrasonic_classifier/run.desktop
sudo chmod -R 775 /home/tegwyn/ultrasonic_classifier/


printf "${GREEN} Now the R packages need to be manually installed: ${NC}\n"
# printf "${GREEN} Don't forget to enable I2C in settings !${NC}\n"

printf "${GREEN}  To install packages, type 'R' in command line and then, one by one: ${NC}\n"
printf "${GREEN}  install.packages("audio") ${NC}\n"
printf "${GREEN}  install.packages("randomForest") ${NC}\n"
printf "${GREEN}  install.packages("bioacoustics") ${NC}\n"





