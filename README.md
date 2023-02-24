# Ultrasonic Classifier for Rock 5B
Due to the current unavailability of both the Jetson Nano and Raspberry Pi 4, the Rock 5B is now the preferred platform for the classifier. It runs on Ubuntu server v.20.04 operating system and a desktop GUI can easily be installed if required. The OS image should be downloaded from the official Rock 5B page and then flashed to an SD card or some other storage medium. These instructions were tested on 24th February 2023 on a 128 Gb Sandisc card. There's also an 'instructions.sh' file in the repository that would be easier to work with than using this readme.

<ins>**The SD card:**</ins>
<br>Use Balena Etcher to install a Rock 5B image on the SD card.
<br>Install the new card in the Rock 5B, connect ethernet cable and mouse, keyboard and monitor and power it up.
<br>Look for the flashing blue LED - might be necessary to reboot a few times. This seems to be some kind of minor bug in the Rock 5B. Initially, it also seems to be fussy about what type of HDMI screen is used.
<br>At command prompt, type:
``sudo apt update && sudo apt upgrade``  (the user is 'rock' and the password is 'rock').

<ins>**To install ubuntu desktop type:**</ins>
<br>``sudo apt install ubuntu-desktop`` 
<br>If errors, repeat above command.
<br>Reboot the Rock 5B.
<br>In settings, add a new user called 'tegwyn' and use password 'rock2023'.
<br>Switch users to tegwyn.

<br>``sudo apt install make`` 
<br>``sudo apt install build-essential`` 
<br>If errors, repeat above command.

<br>Manually download bzip2-1.0.6 from soundforge website:
<br>https://sourceforge.net/projects/bzip2/files/latest/download
<br>It should now be in the downloads folder.
<br>``cd && cd /home/tegwyn/Downloads/`` 
<br>``tar zxvf bzip2-1.0.6.tar.gz``  
<br>``cd bzip2-1.0.6`` 
<br>``sudo make install`` 

<br>sudo apt install -y git
<br>git clone https://github.com/paddygoat/ultrasonic_classifier.git

<ins>**Now download the random forest model files:**</ins>
<br>``sudo apt install -y curl``
<br>``curl -o /home/tegwyn/ultrasonic_classifier/rds_files/rds_files.zip -L 'https://drive.google.com/uc?export=download&confirm=yes&id=1YeJUVu2hnVMerrqBaqQNCimyuveOwVJu'``
<br>``sudo apt install -y unzip``
<br>``unzip /home/tegwyn/ultrasonic_classifier/rds_files/rds_files.zip -d /home/tegwyn/ultrasonic_classifier/rds_files``
<br>``rm /home/tegwyn/ultrasonic_classifier/rds_files/rds_files.zip``
<br>``rm /home/tegwyn/ultrasonic_classifier/rds_files/nothing.txt``

<ins>**Install software tools and libraries:**</ins>
<br>``sudo apt install -y python3-pip``
<br>``sudo apt install -y python3-smbus``
<br>``sudo apt install -y i2c-tools``
<br>``sudo python3 -m pip install git+https://github.com/abelectronicsuk/ABElectronics_Python_Libraries.git``

<br>``sudo apt install -y liblzma-dev``
<br>``sudo apt install -y cmake``
<br>``sudo apt install -y sox libsox-fmt-all``
<br>If errors, repeat above command.
<br>``sudo apt install -y audacity``

<br>``pip3 install cython``
<br>``pip3 install playsound``
<br>``pip3 install pydub``
<br>``pip3 install pathlib2``

<br>``sudo apt install -y gir1.2-appindicator3-0.1``
<br>``sudo apt install -y libcairo2-dev libxt-dev libgirepository1.0-dev``

<br>``pip3 install pycairo PyGObject``
<br>``pip3 install numpy``
<br>``pip3 install matplotlib``
<br>``pip3 install DateTimeRange``
<br>``pip3 install pandas``
<br>``pip3 install colorama``

<br>``sudo apt install -y python3-scipy``
<br>``sudo apt install -y gfortran libreadline6-dev libx11-dev libxt-dev libpng-dev libjpeg-dev libcairo2-dev xvfb libcurl4-openssl-dev texinfo``
<br>If errors, repeat above command.

<ins>**Install R:**</ins>
<br>``sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'``
<br>``sudo apt upgrade``
<br>``sudo apt install focal-cran40``
<br>``sudo apt install R``
<br>``sudo apt-get install -y r-base-dev``
<br>If errors, repeat above command.

<ins>**Change some file permissions:**</ins>
<br>``sudo chmod -R 777 /usr/local/lib/R/site-library``
<br>``sudo chmod -R 777 /usr/local/lib/R/``
<br>``sudo chmod -R 775 /home/tegwyn/ultrasonic_classifier/``

<ins>**Now run R by typing 'R' in command line:**</ins>
<br>``R``

<ins>**Install some R packages:**</ins>
<br>``install.packages("crayon")``
<br>``install.packages("rstudioapi")``
<br>``install.packages("audio")``
<br>``urlPackage <- "https://cran.r-project.org/src/contrib/Archive/randomForest/randomForest_4.6-12.tar.gz"``
<br>``install.packages(urlPackage, repos=NULL, type="source")``
<br>``install.packages("bioacoustics")``
<br>If errors, repeat above command.
<br>Exit R with ctl + z

<ins>**Run the classifier:**</ins>
<br>``cd /home/tegwyn/ultrasonic_classifier/ && ./run.sh``

<br>Rattle some keys near the microphone and a 'UFO' should be detected.









