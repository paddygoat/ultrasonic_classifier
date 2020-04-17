# $ cd /media/tegwyn/Xavier_SD/ultrasonic_classifier/
# $ Rscript Train_bats.R

# $ Rscript install.packages("audio")
# install.packages("audio")
# install.packages("bioacoustics")
# install.packages("randomForest")
# install.packages("rstudioapi")

library(bioacoustics)
library(tools)
library(randomForest)
library(rstudioapi)

# Set up our working directory and data directory:'

setwd("/media/tegwyn/Xavier_SD/ultrasonic_classifier/")
wd <- getwd()         # Working directory
wd
data_dir <- file.path(wd, "data")
data_dir

data_dir_test <- file.path(wd, "unknown_bat_audio")
data_dir_test

BAT_wav <- read_audio(file.path(wd, "data/rhino_hippo/rhino_hippo_lesser_horshoe_20190913_200940 LHS.wav"))
BAT_wav

# Set each argument according to the targeted audio events
TD <- threshold_detection(
  BAT_wav, # Either a path to an audio file (see ?read_audio), or a Wave object
  threshold = 8, # 12 dB SNR sensitivity for the detection algorithm
  time_exp = 1, # Time expansion factor of 1. Only needed for bat recordings.
  min_dur = 0, # Minimum duration threshold of 140 milliseconds (ms)
  max_dur = 20, # Maximum duration threshold of 440 ms
  min_TBE = 10, # Minimum time window between two audio events of 10 milliseconds
  max_TBE = 5000, # Maximum time window between two audio events, here 5 seconds
  EDG = 0.996, # Temporal masking with Exponential Decay Gain from 0 to 1
  LPF = 120000, # Low-Pass Filter of 120 kHz
  HPF = 15000, # High-Pass Filter of 15 kHz
  FFT_size = 256, # Size of the Fast Fourrier Transform (FFT) window
  FFT_overlap = 0.875, # Percentage of overlap between two FFT windows

  start_thr = 10, # 25 dB threshold at the start of the audio event
  end_thr = 50, # 30 dB threshold at the end of the audio event
  SNR_thr = 5, # 10 dB SNR threshold at which the extraction of the audio event stops
  angle_thr = 45, # 45° of angle at which the extraction of the audio event stops
  duration_thr = 44, # Noise estimation is resumed after 440 ms
  NWS = 100, # Time window length of 1 s used for background noise estimation
  KPE = 1e-05, # Process Error parameter of the Kalman filter (for smoothing)
  KME = 1e-04, # Measurement Error parameter of the Kalman filter (for smoothing)

  settings = FALSE, #  Save on a list the above parameters set with this function
  acoustic_feat = TRUE, # Extracts the acoustic and signal quality parameters 
  metadata = FALSE, # Extracts on a list the metadata embedded with the Wave file
  spectro_dir = file.path(wd), # "spectrograms"), # Directory where to save the spectrograms
  #spectro_dir = NULL,
  time_scale = 0.01, # Time resolution of 2 ms for spectrogram display
  ticks = TRUE # Tick marks and their intervals are drawn on the y-axis (frequencies) 
) 

# Get the number of extracted audio events
nrow(TD$data$event_data)

#######################################################################################
print("Now extracting feature data - many files may not meet the threshold requirements !!!!")
files <- dir(data_dir, recursive = TRUE, full.names = TRUE, pattern = "[.]wav$")

# Detect and extract audio events
TDs <- setNames(
  lapply(
    files,
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
  basename(file_path_sans_ext(files))
)

# Keep only files with data in it
TDs <- TDs[lapply(TDs, function(x) length(x$data)) > 0]

###################################################################################################
bat_train <- function(bat_name)
{
  BAT_wav <- read_audio(file.path(wd, "data/c_pip/c_pip_247.wav"))
  BAT_wav
  files <- dir(data_dir, recursive = TRUE, full.names = TRUE, pattern = "[.]wav$")
  # Keep the extracted feature and merge in a single data frame for further analysis
  Event_data_01 <- do.call("rbind", c(lapply(TDs, function(x) x$data$event_data), list(stringsAsFactors = FALSE)))
  nrow(Event_data_01)
  
  # Compute the number of extracted c_pip calls
  # sum(startsWith(Event_data_01$filename, "c_pip"))

  # Add a "Class" column: eg "c_pip" vs. all other species of bats in the data directory:
  classes_01 <- as.factor(ifelse(startsWith(Event_data_01$filename, bat_name),"YES", "NO"))
  # Possible classes: "c_pip","c_pip",  "f_rhino", "h_rhino", "n_pip", "nattereri", "noctula", "plecotus", "s_pip"
  Event_data_01 <- cbind(data.frame(Class_01 = classes_01), Event_data_01)
  
  # Get rid of the filename and time in the recording
  Event_data_01$filename <- Event_data_01$starting_time <- NULL
  
  #Event_data_01  #Uncomment to see data.
  
  # Split the data in 70% Training / 30% Test sets
  train <- sample(1:nrow(Event_data_01), round(nrow(Event_data_01) * .99))
  Train <- Event_data_01[train,]
  
  test <- setdiff(1:nrow(Event_data_01), train)
  Test <- Event_data_01[test,]
  
  # Train a random forest classifier
  set.seed(666)
  rf_Paddy <- randomForest(Class_01 ~ + duration + freq_max_amp + freq_max + freq_min +
                          bandwidth + freq_start + freq_center + freq_end +
                          freq_knee + fc + freq_bw_knee_fc + bin_max_amp + 
                          pc_freq_max_amp + pc_freq_max + pc_freq_min +
                          pc_knee + temp_bw_knee_fc + slope + kalman_slope +
                          curve_neg + curve_pos_start + curve_pos_end + 
                          mid_offset + smoothness + snr + hd + smoothness,
                        data = Train, importance = FALSE, proximity = FALSE,
                        replace = TRUE, ntree = 4000, mtry = 7)
  rf_Paddy $confusion
  #importance(rf_Paddy )
  #print(rf_Paddy )

  return(rf_Paddy)
}

###################################################################################################
print("Training has now commenced ...... it may take a few minutes ..... please wait !!!!")

bat_name <- "serotine"
rf_serotine <- bat_train(bat_name)
print("serotine:")
rf_serotine $confusion
saveRDS(rf_serotine,"rf_serotine.rds")

bat_name <- "bird"
rf_bird <- bat_train(bat_name)
print("bird:")
rf_bird $confusion
saveRDS(rf_bird,"rf_bird.rds")

bat_name <- "brandt"
rf_brandt <- bat_train(bat_name)
print("brandt:")
rf_brandt $confusion
saveRDS(rf_brandt,"rf_brandt.rds")

bat_name <- "daub"
rf_daub <- bat_train(bat_name)
print("daub:")
rf_daub $confusion
saveRDS(rf_daub,"rf_daub.rds")

bat_name <- "rhino_ferrum"
rf_rhino_ferrum <- bat_train(bat_name)
print("rhino_ferrum:")
rf_rhino_ferrum $confusion
saveRDS(rf_rhino_ferrum,"rf_rhino_ferrum.rds")

bat_name <- "house_keys"
rf_house_keys <- bat_train(bat_name)
print("house_keys:")
rf_house_keys $confusion
saveRDS(rf_house_keys,"rf_house_keys.rds")

bat_name <- "rhino_hippo"
rf_rhino_hippo <- bat_train(bat_name)
print("rhino_hippo:")
rf_rhino_hippo $confusion
saveRDS(rf_rhino_hippo,"rf_rhino_hippo.rds")

bat_name <- "c_pip"
rf_c_pip <- bat_train(bat_name)
print("c_pip:")
rf_c_pip $confusion
saveRDS(rf_c_pip,"rf_c_pip.rds")

bat_name <- "s_pip"
rf_s_pip <- bat_train(bat_name)
print("s_pip:")
rf_s_pip $confusion
saveRDS(rf_s_pip,"rf_s_pip.rds")

bat_name <- "n_pip"
rf_n_pip <- bat_train(bat_name)
print("n_pip:")
rf_n_pip $confusion
saveRDS(rf_n_pip,"rf_n_pip.rds")

bat_name <- "nattereri"
rf_nattereri <- bat_train(bat_name)
print("nattereri:")
rf_nattereri $confusion
saveRDS(rf_nattereri,"rf_nattereri.rds")

bat_name <- "noctula"
rf_noctula <- bat_train(bat_name)
print("noctula:")
rf_noctula $confusion
saveRDS(rf_noctula,"rf_noctula.rds")

bat_name <- "plecotus"
rf_plecotus <- bat_train(bat_name)
print("plecotus:")
rf_plecotus $confusion
saveRDS(rf_plecotus,"rf_plecotus.rds")

bat_name <- "rodent"
rf_rodent <- bat_train(bat_name)
print("rodent:")
rf_plecotus $confusion
saveRDS(rf_plecotus,"rf_rodent.rds")

############################################
# Predict on one unknown wav file:
data_dir_test <- file.path(wd, "unknown_bat_audio")
print(data_dir_test)

#The unknown test file is located in a specific directory:
files_test <- dir(data_dir_test, recursive = TRUE, full.names = TRUE, pattern = "[.]wav$")
files_test

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

# Keep the extracted feature and merge in a single data frame for further analysis
Event_data_test <- do.call("rbind", c(lapply(TDs, function(x) x$data$event_data), list(stringsAsFactors = FALSE)))
nrow(Event_data_test)

# To look at the predictions 
print("Is the unknown wav a c_pip?")
predict(rf_c_pip , Event_data_test[,-1], type = "prob")

print("Is the unknown wav a c_pip?")
head(predict(rf_c_pip , Event_data_test[,-1], type = "prob"))

#######################################################################################
# Let's consolidate the data a bit:
# Create a matrix of prediction results for Class_01, (Nattereri = True)
matrix_01 <- predict(rf_nattereri , Event_data_test[,-1], type = "prob")
# matrix_01
print("Is the unknown wav a nattereri?")
colMeans(matrix_01)

matrix_02 <- predict(rf_c_pip , Event_data_test[,-1], type = "prob")
# matrix_02
print("Is the unknown wav a c_pip?")
colMeans(matrix_02)

#################################################################################
# Let's consolidate all the output data:

consolidate_results <- function(rf)
{
  matrix_M <- predict(rf , Event_data_test[,-1], type = "prob")
  results <- colMeans(matrix_M)
  return(results)
}


# "Is the unknown wav house_keys?"
HOUSE_KEYS <- consolidate_results(rf_house_keys)
HOUSE_KEYS

# "Is the unknown wav a c_pip?"
C_PIP <- consolidate_results(rf_c_pip)
C_PIP
# "Is the unknown wav a s_pip?"
S_PIP <- consolidate_results(rf_s_pip)
S_PIP
# "Is the unknown wav a nattereri?"
NATTERERI <- consolidate_results(rf_nattereri)
NATTERERI
# "Is the unknown wav a noctula?"
NOCTULA <- consolidate_results(rf_noctula)
NOCTULA
# "Is the unknown wav a plecotus?"
PLECOTUS <- consolidate_results(rf_plecotus)
PLECOTUS
# "Is the unknown wav a rhino_hippo?"
RHINO_HIPPO <- consolidate_results(rf_rhino_hippo)
RHINO_HIPPO

# The matrices are of type "double", object of class "c('matrix', 'double', 'numeric')"

penultimate <- rbind(HOUSE_KEYS, C_PIP, S_PIP, NATTERERI, NOCTULA, PLECOTUS, RHINO_HIPPO)

Final_result <- penultimate[order(penultimate[,1], decreasing = FALSE),]
Final_result














