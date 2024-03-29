# $ cd /home/tegwyn/ultrasonic_classifier/ && Rscript deploy_classifier_async_01.R
# $ R --no-save 
# > setwd("/home/tegwyn/ultrasonic_classifier/")

# > print("Hello!")
# > print(setwd)
# > Deploy_bats_pi.R
# $ Rscript Deploy_bats_pi.R

# To install packages, type 'R' in command line and then eg:
# install.packages("audio")
# install.packages("randomForest")
# install.packages("bioacoustics")
# install.packages("crayon")

library(audio)
library(bioacoustics)
library(tools)
library(randomForest)
library(crayon)

setwd("/home/tegwyn/ultrasonic_classifier")
wd <- getwd()         # Working directory
# wd
cat(magenta$bold(wd))
cat('\n')

unlink("/home/tegwyn/ultrasonic_classifier/helpers/classification_finished.txt")

# cat(green('I am a green line ' %+% blue$underline$bold('with a blue substring') %+% yellow$italic(' that becomes yellow and italicised!\n')))
# cat(magenta$bold('Hello world!\n'))

# print("From the R file: Read into memory all the .rds files ..... ")
cat(magenta$bold('From the R file: Firstly, read into memory all the .rds files ..... \n'))
# write.table("Loading models into memory ...", file = "/home/tegwyn/ultrasonic_classifier/helpers/status_update.txt")
fileConn<-file("/home/tegwyn/ultrasonic_classifier/helpers/status_update.txt")
writeLines(c("Loading models into memory ..."), fileConn)
close(fileConn)

cat("\n")
# Read all the .rds files into RAM or zRAM, once only:
############################################################################
rf_c_pip_file <- readRDS('rds_files/rf_c_pip.rds')
rf_s_pip_file <- readRDS('rds_files/rf_s_pip.rds')
rf_nattereri_file <- readRDS('rds_files/rf_nattereri.rds')
rf_noctula_file <- readRDS('rds_files/rf_noctula.rds')
rf_plecotus_file <- readRDS('rds_files/rf_plecotus.rds')
rf_rhino_hippo_file <- readRDS('rds_files/rf_rhino_hippo.rds')
rf_house_keys_file <- readRDS('rds_files/rf_house_keys.rds')

rf_daub_file <- readRDS('rds_files/rf_daub.rds')
rf_n_pip_file <- readRDS('rds_files/rf_n_pip.rds')
rf_brandt_file <- readRDS('rds_files/rf_brandt.rds')
rf_bird_file <- readRDS('rds_files/rf_bird.rds')
rf_barba_file <- readRDS('rds_files/rf_barba.rds')
rf_rhino_ferrum_file <- readRDS('rds_files/rf_rhino_ferrum.rds')
rf_rodent_file <- readRDS('rds_files/rf_rodent.rds')
rf_serotine_file <- readRDS('rds_files/rf_serotine.rds')
############################################################################

cat(magenta$bold('From the R file: .rds files now loaded!\n'))
fileConn<-file("/home/tegwyn/ultrasonic_classifier/helpers/status_update.txt")
writeLines(c("Start classification ..."), fileConn)
close(fileConn)

while (file.exists("/home/tegwyn/ultrasonic_classifier/helpers/start.txt"))
{
	# print("From the R file: start.txt exists !")
	cat(magenta$bold('... '))                                                                                       # Heart beat.
	# cat(magenta$bold('From the R file: start.txt exists !\n'))
	if (file.exists("/home/tegwyn/ultrasonic_classifier/helpers/classification_finished.txt"))
	{
		# print("From the R file: classification_finished.txt exists!")
		# cat(magenta$bold('From the R file: classification_finished.txt exists!!\n'))
	} else {
		# cat(magenta$bold('From the R file: classification_finished.txt DOES NOT exist!\n'))
		# print("From the R file: classification_finished.txt DOES NOT exist!")
	}
	if ((file.exists("/home/tegwyn/ultrasonic_classifier/helpers/filtered_wav_ready.txt")) && (!file.exists("/home/tegwyn/ultrasonic_classifier/helpers/classification_finished.txt")))
	{
		# print("From the R file: filtered.wav exists!")
		cat(magenta$bold('From the R file: filtered.wav exists!\n'))
		fileConn<-file("/home/tegwyn/ultrasonic_classifier/helpers/status_update.txt")
		writeLines(c("Found audio to classify ..."), fileConn)
		close(fileConn)
		# print("From the R file: Delete Final_result.txt:")

		# delete some files:
		unlink("/home/tegwyn/ultrasonic_classifier/helpers/filtered_wav_ready.txt")
		unlink("Final_result.txt")
		############################################
		# Predict on one unknown wav file:
		# print("From the R file: find the unknown bat for prediction:")
		data_dir_test <- file.path(wd, "unknown_bat_audio")
		# print(data_dir_test)

		#The unknown test file is located in a specific directory:
		files_test <- dir(data_dir_test, recursive = TRUE, full.names = TRUE, pattern = "[.]wav$")

		# print("From the R file: This is the name of the current audio file being processed:")
		# files_test

		# Detect and extract audio events from our unknown test file:
		TDs <- setNames(
		  lapply(
			files_test,
			threshold_detection,
			threshold = 3, 
			min_dur = 1, 
			max_dur = 80, 
			min_TBE = 50, 
			max_TBE = Inf,
			LPF = 120000, 
			HPF = 15000, 
			FFT_size = 256, 
			start_thr = 30, 
			end_thr = 20, 
			SNR_thr = 5, 
			angle_thr = 125, 
			duration_thr = 400, 
			spectro_dir = NULL,
			NWS = 2000, 
			KPE = 0.00001, 
			time_scale = 2, 
			EDG = 0.996
		  ),
		  basename(file_path_sans_ext(files_test))
		)

		# Keep only files with data in it
		TDs <- TDs[lapply(TDs, function(x) length(x$data)) > 0]

		# print(function(x) length(x$data))
		# print("Above.")
		# Keep the extracted feature and merge in a single data frame for further analysis
		Event_data_test <- do.call("rbind", c(lapply(TDs, function(x) x$data$event_data), list(stringsAsFactors = FALSE)))

		nrow(Event_data_test)
		num_audio_events <- nrow(Event_data_test)
		
		#TODO: Why does >0 not work ?????
		if (num_audio_events >1)
		{
			fileConn<-file("/home/tegwyn/ultrasonic_classifier/helpers/status_update.txt")
			writeLines(c("Audio events found !!"), fileConn)
			close(fileConn)

			consolidate_results <- function(rf)
			{
			  matrix_M <- predict(rf , Event_data_test[,-1], type = "prob")
			  results <- colMeans(matrix_M)
			  return(results)
			}

			# "Is the unknown wav house_keys?"
			UFO <- consolidate_results(rf_house_keys_file)
			# HOUSE_KEYS
			# "Is the unknown wav a c_pip?"
			C_PIP <- consolidate_results(rf_c_pip_file)
			# C_PIP
			# "Is the unknown wav a s_pip?"
			S_PIP <- consolidate_results(rf_s_pip_file)
			# S_PIP
			# "Is the unknown wav a nattereri?"
			NATTERERI <- consolidate_results(rf_nattereri_file)
			# NATTERERI
			# "Is the unknown wav a noctula?"
			NOCTULA <- consolidate_results(rf_noctula_file)
			# NOCTULA
			# "Is the unknown wav a plecotus?"
			PLECOTUS <- consolidate_results(rf_plecotus_file)
			# PLECOTUS
			# "Is the unknown wav a rhino_hippo?"
			RHINO_HIPPO <- consolidate_results(rf_rhino_hippo_file)
			# RHINO_HIPPO
			
			DAUB <- consolidate_results(rf_daub_file)
			BIRD <- consolidate_results(rf_bird_file)
			BRANDT <- consolidate_results(rf_brandt_file)
			RODENT <- consolidate_results(rf_rodent_file)
			N_PIP <- consolidate_results(rf_n_pip_file)
			BARBA <- consolidate_results(rf_barba_file)
			RHINO_FERRUM <- consolidate_results(rf_rhino_ferrum_file)
			SEROTINE <- consolidate_results(rf_serotine_file)

			# The matrices are of type "double", object of class "c('matrix', 'double', 'numeric')"

			penultimate <- rbind(C_PIP, S_PIP, NATTERERI, NOCTULA, PLECOTUS, RHINO_HIPPO, UFO, DAUB, BIRD, BRANDT, RODENT, N_PIP, BARBA, RHINO_FERRUM, SEROTINE)

			Final_result <- penultimate[order(penultimate[,1], decreasing = FALSE),]
			# importance(rf_c_pip_file)
			print(Final_result)
			# print(num_audio_events)

			##################################################################################################################################
			# Classification has finished.
			write.table("", file = "/home/tegwyn/ultrasonic_classifier/helpers/classification_finished.txt")
			##################################################################################################################################

			# print("This, below, gives nice new set of row labels:")
			df99 <- cbind(rownames(Final_result), data.frame(Final_result, row.names=NULL))

			# Then we can get variables such as batName:
			# print("This is the bat name from the new data:")
			currBatName <- df99[c(1),c(1)]
			cat(magenta$bold('From the R file: currBatName: ',currBatName,'\n'))
			
			confidence <- df99[c(1),c(3)]
			confidence <- confidence * 100
			cat(magenta$bold('From the R file: confidence: ',confidence,'\n'))
			
			currBatNameChar <- sapply(currBatName, as.character)                       # Convert to a character vector.

			t = as.integer( as.POSIXct( Sys.time()))

			tMillisCurrent = as.integer( as.POSIXct( Sys.time()))
			num_species = 1                                                            # This get overwritten if csv file is found.
			n = num_species
			blank = "blank"
			time_limit = 601

			##################################################################################################################################
			if(confidence > 10)
			{

				if(file.exists("/home/tegwyn/ultrasonic_classifier/helpers/barchart_time.txt"))
				{
					value <- read.table("/home/tegwyn/ultrasonic_classifier/helpers/barchart_time.txt")
					time_limit <- value[c(1),c(1)]
					# print("Imported time_limit:")
					cat(magenta$bold('From the R file: Imported time_limit:\n'))
					print(time_limit)
				}

				##################################################################################################################################

				if((file.exists("From_R_01.csv")) )
				{
					prevData <- read.csv("From_R_01.csv")
					# Read the previous time cell:
					newValue <- prevData[c(1),c(1)]
					tMillisPrevious = newValue
					
					# Calculate time interval:
					timeInterval = tMillisCurrent - tMillisPrevious
					# print("Time interval: ")
					cat(magenta$bold('From the R file: Time interval:\n'))
					print(timeInterval)

				###########################################################################################################################
					# 1.This is for the case where there is a species name AND we're within the time limit:
					if((currBatNameChar %in% colnames(prevData)) & (timeInterval < time_limit) )
					{
						# print("Yep, it's in there!")
						# Lets add the new data bat frequency integer ,num_audio_events, to the old:
						prevValue <- prevData["1", currBatNameChar]
						newValue = prevValue + num_audio_events
						
						# print("This is the number of rows in the dataframe:")
						# print(nrow(prevData))

						prevData["1", currBatNameChar] <- newValue                                  # This is where a new value is inserted into a cell.

				##########################################################################################################################
					# 2.This is for the case where there is no species name AND we've passed the time limit:
					} else if (( timeInterval > time_limit) & !(currBatNameChar %in% colnames(prevData))) {

						# print("The bat name was not there!")
						
						# Firstly, duplicate row 1, which is the latest row, dataFrame[1,]:
						prevData <- rbind(prevData[1,], prevData)
						# print("Did this dupicate the rows ... YES !!!!")
						# print(prevData)

						# Now set all the values of row 1 to zero:
						value = 0                                                         # (num_audio_events = 0)
						prevData["1",] <- value                                # All rows in species column
						# print("What does the new dataframe look like? .... TWO ")
						# print(prevData)

						# Now to create our new data column:
						df9 <- data.frame(placeholder_name = 1)
						names(df9)[names(df9) == "placeholder_name"] <- currBatNameChar
						# print("This below should now have column names:")
						# df9

						# Now try and replace the placeholder with num_audio_events:
						# But, initially, set all the new num_audio_events cells to something temporary:
						# ferrets = 99
						# df9["1", currBatNameChar] <- ferrets
						# print("What does the ferrets dataframe look like?")
						# print(df9)

						# Now insert a new value for num_audio_events into row 1, the new column:
						df9["1", currBatNameChar] <- num_audio_events
						# print("Now we have our new dataframe with some useful data:")
						# df9
						# print(df9)
						
						# Now add the new column:
						prevData <- cbind(prevData, df9) 
						
						# Now set all the values of column bat name to zero:
						value = "0"                                                         # (num_audio_events = 0)
						prevData[,currBatNameChar] <- value                                # All rows in species column
						# print("What does the new dataframe look like? .... TWO ")
						# print(prevData)
						
						# Then set the first row to correct num_audio_events value:
						value = num_audio_events
						prevData["1", currBatNameChar] <- value                             # Latest row only
						# print("What does the new dataframe look like? ...... THREE")
						# print(prevData)

						# The time cell gets set to zero, so put the time value back into that cell:
						value = tMillisCurrent 
						prevData["1", "BLANK"] <- value                             # Latest row only, time column = BLANK
						# print("What does the new dataframe look like? ...... FOUR")
						# print(prevData)
						
				##############################################################################################################
					# 3.This is for the case where there is a species name AND we're outside the time limit:
					} else if ((currBatNameChar %in% colnames(prevData)) & ( timeInterval > time_limit))  {

						# Firstly, duplicate row 1, which is the latest row, dataFrame[1,]:
						prevData <- rbind(prevData[1,], prevData)
						# print("Did this dupicate the rows ... YES !!!!")
						# print(prevData)

						# Now insert the new value of time into the new dataframe row:
						value = t
						prevData["1", "BLANK"] <- value

						
						# Now set all the values of row 1 to zero:
						value = 0                                                         # (num_audio_events = 0)
						prevData["1",] <- value                                # All rows in species column
						# print("What does the new dataframe look like? .... TWO ")
						# print(prevData)
						
						
						# Then set the first row to correct num_audio_events value:
						value = num_audio_events
						prevData["1", currBatNameChar] <- value                             # Latest row only
						# print("What does the new dataframe look like? ...... THREE")
						# print(prevData)

						# The time cell gets set to zero, so put the time value back into that cell:
						value = tMillisCurrent 
						prevData["1", "BLANK"] <- value                             # Latest row only, time column = BLANK
						# print("What does the new dataframe look like? ...... FOUR")
						# print(prevData)

				##########################################################################################################################
					# 4.This is for the case where there is no species name AND we're within the time limit:
					} else if (( timeInterval < time_limit) & !(currBatNameChar %in% colnames(prevData))) {

						# print("The bat name was not there!")
						# Now to create our new data column:
						df9 <- data.frame(placeholder_name = 1)
						names(df9)[names(df9) == "placeholder_name"] <- currBatNameChar

						# Now insert a new value for num_audio_events into row 1:
						df9["1", currBatNameChar] <- num_audio_events
						print("Now we have our new dataframe with some useful data:")
						df9
						# print(df9)
						# Now add the new column:
						prevData <- cbind(prevData, df9) 

						# Set all the values of bat frequency, num_audio_events, of the new species column, into the new dataframe as zero:
						value = 0                                                         # (num_audio_events = 0)
						prevData[, currBatNameChar] <- value                                # All rows in species column
						# print("What does the new dataframe look like? .... FIVE ")
						# print(prevData)

						# Then set the first row to correct num_audio_events value:
						value = num_audio_events
						prevData["1", currBatNameChar] <- value                             # Latest row only
						# print("What does the new dataframe look like? ...... SIX")
						# print(prevData)

					}

				# 5.This is the case where there is no csv file:
				} else {
						print("No csv file exists ..... ")
						df14 <- t                                                             # Add time stamp
						df15 <- data.frame(df14)
						colnames(df15) <- c("BLANK")
						prevData <- df15
						
						# print("The bat name was not there!")
						# Now to create our new data column:
						df9 <- data.frame(placeholder_name = 1)
						names(df9)[names(df9) == "placeholder_name"] <- currBatNameChar

						# Now insert a new value for num_audio_events into row 1:
						df9["1", currBatNameChar] <- num_audio_events
						# print("Now we have our new dataframe with some useful data:")
						# print(df9)
						
						# Now add the new column:
						prevData <- cbind(prevData, df9) 

						# Set all the values of bat frequency, num_audio_events, of the new species column, into the new dataframe as zero:
						value = 0                                                         # (num_audio_events = 0)
						prevData[, currBatNameChar] <- value                                # All rows in species column
						# print("What does the new dataframe look like? .... FIVE ")
						# print(prevData)

						# Then set the first row to correct num_audio_events value:
						value = num_audio_events
						prevData["1", currBatNameChar] <- value                             # Latest row only
						# print("What does the new dataframe look like? ...... SIX")
						# print(prevData)
						
						# print("This should be the new csv file to save?")
						# print(df15)
						write.table(df15, file = "From_R_01.csv", sep = ",", row.names = FALSE, col.names = TRUE)
				} # (if(file.exists("From_R_01.csv")))

				# print("Now we have our new prevData dataframe with some useful data:")
				cat(magenta$bold('Now we have our new prevData dataframe with some useful data:\n'))
				print(prevData)

				# print("END")

				write.table(Final_result, file = "Final_result.txt", sep = "\t", row.names = TRUE, col.names = NA)
				# write.table(df11, file = "From_R_01.csv", sep = ",", row.names = FALSE, col.names = TRUE)
				write.table(prevData, file = "From_R_01.csv", sep = ",", row.names = FALSE, col.names = TRUE)
				# write.table("", file = "/home/tegwyn/ultrasonic_classifier/helpers/classification_finished.txt")
				
				# Since we have a positive classification result, we can now run the renamimg script, script_3.sh:
				path = "/home/tegwyn/ultrasonic_classifier/script_3.sh"
				cat(magenta$bold('Now try to run script_3.sh:\n'))
				system(path)
				cat(magenta$bold('Did script_3.sh work?:\n'))
				
				# Now run create_spectogram.py or create_graph.py:
				# TODO: Can we remove all references to Final_result.txt in script_3.sh ???
				
				# TODO: we can move this next if section to the set up section later on:
				if(file.exists("/home/tegwyn/ultrasonic_classifier/helpers/toggled_02.txt"))
				{
					value <- read.table("/home/tegwyn/ultrasonic_classifier/helpers/toggled_02.txt")
					text_or_graph_or_spectogram <- value[c(1),c(1)]
					value2 <- read.table("/home/tegwyn/ultrasonic_classifier/helpers/specto_resolution.txt")
					high_or_low_res_spectogram <- value2[c(1),c(1)]
					# print("Imported time_limit:")
					cat(magenta$bold('From the R file: text_or_graph_or_spectogram:\n'))
					print(text_or_graph_or_spectogram)
					cat(magenta$bold('From the R file: high_or_low_res_spectogram:\n'))
					print(high_or_low_res_spectogram)
					
					if (text_or_graph_or_spectogram == "spectogram")
					{
						if (high_or_low_res_spectogram == "LOW")
						{
							cat(magenta$bold('From the R file: LOW resolution was selected !!!:\n'))
							system('python3 /home/tegwyn/ultrasonic_classifier/create_spectogram.py')
						
						} else {
							system('python3 /home/tegwyn/ultrasonic_classifier/create_spectogram_batch_process.py')
							cat(magenta$bold('From the R file: HIGH resolution was selected !!!:\n'))
						}
					} else if (text_or_graph_or_spectogram == "graph") {
						system('python3 /home/tegwyn/ultrasonic_classifier/create_barchart.py')
					}
				}
			}                                       # if confidence > 10
		} else {                                    # if (num_audio_events >1)
		# print("Although a filtered.wav file was found, it did not have any audio events in it !!!!")
		# cat(magenta$bold('From the R file: Although a filtered.wav file was found, it did not have any audio events in it !!!!\n'))
		write.table("", file = "/home/tegwyn/ultrasonic_classifier/helpers/classification_finished.txt")
		fileConn<-file("/home/tegwyn/ultrasonic_classifier/helpers/status_update.txt")                     # GUI displays live status update.
		writeLines(c("No audio events detected !!"), fileConn)
		close(fileConn)
		Sys.sleep(0.5)
		}
	} else {                                        # if (file.exists("/home/tegwyn/ultrasonic_classifier/unknown_bat_audio/filtered.wav"))
		# print("No filtered.wav was detected in unknown_bat_audio folder OR classification_finished.txt might exist")
		# cat(magenta$bold('From the R file: No filtered.wav was detected in unknown_bat_audio folder OR classification_finished.txt might exist!\n'))
		# cat("\n")
		Sys.sleep(0.5)
	}
}                                                   #  while (file.exists("/home/tegwyn/ultrasonic_classifier/helpers/start.txt"))
q()



