import ftplib
session = ftplib.FTP('ftp.goatindustries.co.uk','paddygoat2@goatindustries.co.uk','PASSWORD')
file = open('/media/tegwyn/Xavier_SD/dog-breed-identification/build/dataset/daub_spectographs/daub_0.5_2422_1_1.jpg','rb')                  # file to send
session.storbinary('STOR bat_detector/kitten2.jpg', file)     # send the file
file.close()                                    # close file and FTP
session.quit()
