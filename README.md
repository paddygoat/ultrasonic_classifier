# Ultrasonic Classifier for Jetson Nano

1. Flash a 128 Gb SD card with the Jetson Nano image using Balena Etcher or such like.
2. Boot up the Nano and create a new user called tegwyn.
3. Open a terminal and run: git clone https://github.com/paddygoat/ultrasonic_classifier.git
4. Find the file: ultrasonic_classifier_dependancies_install_nano.sh in ultrasonic_classifier and open it in a text editor.
5. Follow the instructions within. The whole script could be run from a terminal using: 

cd /home/tegwyn/ultrasonic_classifier/ && chmod 775 ultrasonic_classifier_dependancies_install_nano.sh && bash ultrasonic_classifier_dependancies_install_nano.sh

.... Or install each line one by one for better certainty of success.
6. Find the file: run.sh in the ultrasonic_classifier directory and edit the password accordingly.
