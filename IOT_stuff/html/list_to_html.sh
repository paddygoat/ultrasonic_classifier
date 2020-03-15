#!/bin/bash
# cd /home/tegwyn/ultrasonic_classifier/IOT_stuff/html/ && bash list_to_html.sh


cd /home/tegwyn/ultrasonic_classifier/detected_bat_audio
exec > /home/tegwyn/ultrasonic_classifier/IOT_stuff/html/saved_audio_files.html


printf '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">'
printf '<html>'
printf '<head>'
  printf '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">'
  printf '<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">'

  printf '<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">'
  printf '<meta http-equiv="Pragma" content="no-cache">'
  printf '<meta http-equiv="Expires" content="0">'
  
  printf '<meta http-equiv='refresh' content='60';url='saved_audio_files.html'> <!-- Refreshes page every 60 seconds -->'
  printf '<META NAME="description" CONTENT="Intelligent Bat Detector ... Are not all bats intelligent?">'

  printf '<META NAME="keywords" CONTENT="Intelligent Bat Detector random forest classification deep learning raspberry pi jetson nano 4g LTE">'

  printf '<link REL="SHORTCUT ICON" HREF="http://www.goatindustries.co.uk/goat.ico">'
  printf '<title>Intelligent Bat Detector - Audio files saved</title>'





printf '<body>\n<table>\n'
// printf '<button type="button" onclick="alert("Hello world!")">Click Me!</button>'
printf '<a href="http://www.goatindustries.co.uk/bat_detector/showdata.php"><button>Back to Main Page</button></a>'

printf '<td>Saved audio files:</td>\n'

for file in *; do
  stat "$file" -c '<tr><td>%n</td><td>%y</td></tr>' | sort -nr
done

printf '</table>\n</body>\n</head>\n</html>\n'
