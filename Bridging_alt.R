# Just for the first time you use this script, select all of line 2 and 3 to install devtools and "OlinkAnalyze"
install.packages("devtools")
devtools::install_github(repo ='Olink-Proteomics/OlinkRPackage/OlinkAnalyze')

# load OlinkAnalyze
library(OlinkAnalyze)

# read both olink NPX datasets
# just type the filepath in the quotes on the next two lines and run the code

file1 <- "/Users/natalie/Documents/Olink/Q044 GCA_PMR Inflammation Plates 2 to 4 _NPX.xlsx"
file2 <- "/Users/natalie/Documents/Olink/Q044 GCA PMR Inflammation Plate 1 REPEAT 091220 _NPX.xlsx"



# these two commands will upload the files to R
my_NPX_data_plate_2_4 <- read_NPX(filename = file1)
my_NPX_data_plate_1 <- read_NPX(filename = file2)


# identify bridge samples by running the next two lines
bridge_samples <- intersect(x = my_NPX_data_plate_1$SampleID, #reference
                            y = my_NPX_data_plate_2_4$SampleID) #data to normalize

# run the next line to look at the list of bridge samples and note down any controls/any others you dont recognise to be bridges
bridge_samples


# list the samples you dont recognise in quotes on the line below (each ID within the brackets, inside quotes and separated by commas)
# then run the next line to "save" them
remove <- c("PP1", "PP2", "Neg1", "Neg2", "Neg3", "IPC1", "IPC2", "IPC3")

#then remove those samples by running the next line
bridge_samples <- setdiff(bridge_samples, remove)


# run the next lines to normalize the data using the bridging samples
bridge_normalized_data <- olink_normalization(df1 = my_NPX_data_plate_1,
                                              df2 = my_NPX_data_plate_2_4,
                                              overlapping_samples_df1 = bridge_samples,
                                              df1_project_nr = "3022",
                                              df2_project_nr = "3021",
                                              reference_project = "3022")

# save the data as an excel table 
write.xlsx(bridge_normalized_data, "/Users/natalie/Documents/Olink/bridge_normalized_data_plate_1_to_4.xlsx")




