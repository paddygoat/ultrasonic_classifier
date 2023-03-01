# Use Balena Etcher to install a Rock 5B image on the SD card.
# Install the new cardin the Rock 5B, connect ethernet cable and mous, keyboard and monitor and power it up.
# Look for the flashing blue LED, might be necessary to reboot a few times.
# At command prompt, type:
sudo apt update && sudo apt upgrade (the user is 'rock' and the password is 'rock').
# To install ubuntu desktop type:
sudo apt install ubuntu-desktop
# If errors, repeat above command.
# Reboot the Rock 5B.
# In settings, add a new user called 'tegwyn'.
# Switch users to tegwyn.

sudo apt install make
sudo apt install build-essential
# If errors, repeat above command.

# Manually download bzip2-1.0.6 from soundforge website:
https://sourceforge.net/projects/bzip2/files/latest/download
It should now be in the downloads folder.
cd && cd /home/tegwyn/Downloads/
tar zxvf bzip2-1.0.6.tar.gz 
cd bzip2-1.0.6
sudo make install

sudo apt install -y git
git clone https://github.com/paddygoat/ultrasonic_classifier.git

# Now download the random forest model files:
sudo apt install -y curl
curl -o /home/tegwyn/ultrasonic_classifier/rds_files/rds_files.zip -L 'https://drive.google.com/uc?export=download&confirm=yes&id=1YeJUVu2hnVMerrqBaqQNCimyuveOwVJu'
sudo apt install -y unzip
unzip /home/tegwyn/ultrasonic_classifier/rds_files/rds_files.zip -d /home/tegwyn/ultrasonic_classifier/rds_files
rm /home/tegwyn/ultrasonic_classifier/rds_files/rds_files.zip
rm /home/tegwyn/ultrasonic_classifier/rds_files/nothing.txt

# Install software tools and libraries:
sudo apt install -y python3-pip
sudo apt install -y python3-smbus
sudo apt install -y i2c-tools
sudo python3 -m pip install git+https://github.com/abelectronicsuk/ABElectronics_Python_Libraries.git

sudo apt install -y liblzma-dev
sudo apt install -y cmake
sudo apt install -y sox libsox-fmt-all
# If errors, repeat above command.
sudo apt install -y audacity

pip3 install cython
pip3 install playsound
pip3 install pydub
pip3 install pathlib2

sudo apt install -y gir1.2-appindicator3-0.1
sudo apt install -y libcairo2-dev libxt-dev libgirepository1.0-dev

pip3 install pycairo PyGObject
pip3 install numpy
pip3 install matplotlib
pip3 install DateTimeRange
pip3 install pandas
pip3 install colorama

sudo apt install -y python3-scipy
sudo apt install -y gfortran libreadline6-dev libx11-dev libxt-dev libpng-dev libjpeg-dev libcairo2-dev xvfb libcurl4-openssl-dev texinfo
# If errors, repeat above command.

# Install R:
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
sudo apt upgrade
# sudo apt install focal-cran40
# sudo apt install R
sudo apt-get install -y r-base-dev
# If errors, repeat above command.

# Change some file permissions:
sudo chmod -R 777 /usr/local/lib/R/site-library
sudo chmod -R 777 /usr/local/lib/R/
sudo chmod -R 775 /home/tegwyn/ultrasonic_classifier/

# Now run R by typing 'R' in command line:
R

# Install some R packages:
install.packages("crayon")
install.packages("rstudioapi")
install.packages("audio")
urlPackage <- "https://cran.r-project.org/src/contrib/Archive/randomForest/randomForest_4.6-12.tar.gz"
install.packages(urlPackage, repos=NULL, type="source") 
install.packages("bioacoustics")
# If errors, repeat above command.
# Exit R with ctl + z

# Run the classifier:
cd /home/tegwyn/ultrasonic_classifier/ && ./run.sh

# Rattle some keys near the microphone and a 'UFO' should be detected.










