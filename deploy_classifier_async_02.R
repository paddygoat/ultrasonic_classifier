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

setwd("/home/tegwyn/ultrasonic_classifier/")
wd <- getwd()         # Working directory
# wd
cat(magenta$bold(wd))
cat('\n')

unlink("/home/tegwyn/ultrasonic_classifier/helpers/classification_finished.txt")

# cat(green('I am a green line ' %+% blue$underline$bold('with a blue substring') %+% yellow$italic(' that becomes yellow and italicised!\n')))
# cat(magenta$bold('Hello world!\n'))

# print("From the R file: Read into memory all the .rds files ..... ")
cat(magenta$bold('From the R file: Firstly, read into memory all the .rds files ..... \n'))
cat("\n")
# Read all the .rds files into RAM or zRAM, once only:
############################################################################
rf_house_keys_file <- readRDS('rf_house_keys.rds')
rf_rhino_file <- readRDS('rf_rhino.rds')
rf_myotis_file <- readRDS('rf_myotis.rds')
rf_nyctalus_file <- readRDS('rf_nyctalus.rds')
rf_pipi_file <- readRDS('rf_pipi.rds')
rf_plecotus_file <- readRDS('rf_plecotus.rds')
rf_barba_file <- readRDS('rf_barba.rds')
############################################################################

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
			consolidate_results <- function(rf)
			{
			  matrix_M <- predict(rf , Event_data_test[,-1], type = "prob")
			  results <- colMeans(matrix_M)
			  return(results)
			}

			# "Is the unknown wav house_keys?"
			HOUSE_KEYS <- consolidate_results(rf_house_keys_file)
			RHINO <- consolidate_results(rf_rhino_file)
			MYOTIS <- consolidate_results(rf_myotis_file)
			NYCTALUS <- consolidate_results(rf_nyctalus_file)
			PIPI <- consolidate_results(rf_pipi_file)
			PLECOTUS <- consolidate_results(rf_plecotus_file)
			BARBA <- consolidate_results(rf_barba_file)

			# The matrices are of type "double", object of class "c('matrix', 'double', 'numeric')"

			penultimate <- rbind(HOUSE_KEYS, RHINO, MYOTIS, NYCTALUS, PIPI, PLECOTUS, BARBA)

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
			currBatName
			currBatNameChar <- sapply(currBatName, as.character)                       # Convert to a character vector.

			t = as.integer( as.POSIXct( Sys.time()))

			tMillisCurrent = as.integer( as.POSIXct( Sys.time()))
			num_species = 1                                                            # This get overwritten if csv file is found.
			n = num_species
			blank = "blank"
			time_limit = 601

			##################################################################################################################################

			if(file.exists("/home/tegwyn/ultrasonic_classifier/helpers/barchart_time.txt"))
			{
				value <- read.table("/home/tegwyn/ultrasonic_classifier/helpers/barchart_time.txt")
				time_limit <- value[c(1),c(1)]
				# print("Imported time_limit:")
				cat(magenta$bold('From the R file: Imported time_limit:\n'))
				print(time_limit)
			}

			##################################################################################################################################

			if(file.exists("From_R_01.csv"))
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
				if((currBatNameChar %in% colnames(prevData)) & (timeInterval < time_limit))
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
				# print("Imported time_limit:")
				cat(magenta$bold('From the R file: text_or_graph_or_spectogram:\n'))
				print(text_or_graph_or_spectogram)
				
				if (text_or_graph_or_spectogram == "spectogram")
				{
					system('python3 /home/tegwyn/ultrasonic_classifier/create_spectogram.py')
				} else if (text_or_graph_or_spectogram == "graph") {
					system('python3 /home/tegwyn/ultrasonic_classifier/create_barchart.py')
				}
			}
			
		} else {                                    # if (num_audio_events >1)
		# print("Although a filtered.wav file was found, it did not have any audio events in it !!!!")
		# cat(magenta$bold('From the R file: Although a filtered.wav file was found, it did not have any audio events in it !!!!\n'))
		write.table("", file = "/home/tegwyn/ultrasonic_classifier/helpers/classification_finished.txt")
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
