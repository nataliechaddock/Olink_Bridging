# Just for the first time you use this script, select all of line 2 and 3 to install devtools and "OlinkAnalyze"
install.packages("devtools")
devtools::install_github(repo ='Olink-Proteomics/OlinkRPackage/OlinkAnalyze')

# load OlinkAnalyze
library(OlinkAnalyze)
library(xlsx)

# read both olink NPX datasets
# just type the filepath in the quotes on the next two lines and run the code

file1 <- "/Users/natalie/Documents/Olink/New/Q044 GCA INF and CDM_NPX citrate plasma.xlsx"
file2 <- "/Users/natalie/Documents/Olink/New/Q044 GCA INF Plate1_REPEAT_citrate plasma NPX.xlsx"

# these two commands will upload the files to R
my_NPX_data_plate_2_4 <- read_NPX(filename = file1)
my_NPX_data_plate_1 <- read_NPX(filename = file2)

# remove Cardiometabolic panel
my_NPX_data_plate_2_4 <- my_NPX_data_plate_2_4[my_NPX_data_plate_2_4$Panel != "Olink Cardiometabolic",]

# identify bridge samples by running the next two lines
bridge_samples <- intersect(x = my_NPX_data_plate_1$SampleID, #reference
                            y = my_NPX_data_plate_2_4$SampleID) #data to normalize

# run the next line to look at the list of bridge samples and note down any controls/any others you dont recognise to be bridges
bridge_samples

# check that our bridging samples are in the "bridge_samples" list
actual_bridges <- c("01-112", "10-013", "12-030", "12-093")
actual_bridges %in% bridge_samples

# none of them are present, so investigate why
# after investigating, it turns out that the bridging samples are labelled "(Bridging)" after the sample ID in plate 1
# so just remove this trailing part to make the sample IDs identical
my_NPX_data_plate_1$SampleID <- gsub("[ (Bridging)]", "", my_NPX_data_plate_1$SampleID)

# repeat previous steps
# identify bridge samples by running the next two lines
bridge_samples <- intersect(x = my_NPX_data_plate_1$SampleID, #reference
                            y = my_NPX_data_plate_2_4$SampleID) #data to normalize
actual_bridges %in% bridge_samples
# if this results in all TRUE, no FALSE, you can use the "actual_bridges" list to bridge samples successfully


# run the next lines to normalize the data using the bridging samples
bridge_normalized_data <- olink_normalization(df1 = my_NPX_data_plate_1,
                                              df2 = my_NPX_data_plate_2_4,
                                              overlapping_samples_df1 = actual_bridges,
                                              df1_project_nr = "3022",
                                              df2_project_nr = "3021",
                                              reference_project = "3022")

# save the data as an NPX table 
write.xlsx(bridge_normalized_data, "/Users/natalie/Documents/Olink/New/bridge_normalized_data_plate_1_to_4.xlsx")





