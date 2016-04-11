
download.file("http://www3.stats.govt.nz/meshblock/2013/csv/2013_mb_dataset_Total_New_Zealand_CSV.zip",
              destfile = "downloads/census2013/2013_mb_census.zip", mode = "wb")

unzip("downloads/census2013/2013_mb_census.zip", exdir = "downloads/census2013")



#-------------------selected dwellings variables-----------------
dwelling_orig <- read.csv("downloads/census2013/2013-mb-dataset-Total-New-Zealand-Dwelling.csv",
                     stringsAsFactors = FALSE, na.strings = "..C")
names(dwelling)
head(dwelling$Code)
head(Locations2014$MB2014)
head(dwelling)

dwelling <- dwelling_orig %>%
    rename(MB2014 = Code, 
           MeanBedrooms2013 = X2013_Census_number_of_bedrooms_for_occupied_private_dwellings_Mean_Number_of_Bedrooms) %>%
    mutate(PropPrivateDwellings2013 = X2013_Census_dwelling_record_type_for_occupied_dwellings_Occupied_Private_Dwelling /
               X2013_Census_dwelling_record_type_for_occupied_dwellings_Total_occupied_dwellings,
           PropSeparateHouse2013 = X2013_Census_occupied_private_dwelling_type_Separate_House / 
               X2013_Census_occupied_private_dwelling_type_Total_occupied_private_dwellings
           ) %>%
    select(MB2014, MeanBedrooms2013, PropPrivateDwellings2013, PropSeparateHouse2013)

head(dwelling)


#-----------------------finish-------------------
save(Meshblocks2014, file = "pkg/data/Meshblocks2014.rda")
     