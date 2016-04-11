
download.file("http://www3.stats.govt.nz/meshblock/2013/csv/2013_mb_dataset_Total_New_Zealand_CSV.zip",
              destfile = "downloads/census2013/2013_mb_census.zip", mode = "wb")

unzip("downloads/census2013/2013_mb_census.zip", exdir = "downloads/census2013")



#-------------------selected dwellings variables-----------------
tmp_orig <- read.csv("downloads/census2013/2013-mb-dataset-Total-New-Zealand-Dwelling.csv",
                     stringsAsFactors = FALSE, na.strings = "..C")


dwelling <- tmp_orig %>%
    rename(MB = Code, 
           MeanBedrooms2013 = X2013_Census_number_of_bedrooms_for_occupied_private_dwellings_Mean_Number_of_Bedrooms) %>%
    mutate(PropPrivateDwellings2013 = X2013_Census_dwelling_record_type_for_occupied_dwellings_Occupied_Private_Dwelling /
               X2013_Census_dwelling_record_type_for_occupied_dwellings_Total_occupied_dwellings,
           PropSeparateHouse2013 = X2013_Census_occupied_private_dwelling_type_Separate_House / 
               X2013_Census_occupied_private_dwelling_type_Total_occupied_private_dwellings
           ) %>%
    select(MB, MeanBedrooms2013, PropPrivateDwellings2013, PropSeparateHouse2013)


#-------------------selected household variables--------------------
tmp_orig <- read.csv("downloads/census2013/2013-mb-dataset-Total-New-Zealand-Household.csv",
                     stringsAsFactors = FALSE, na.strings = "..C")

hh <- tmp_orig %>%
    rename(MB = Code) %>%
    mutate(
        NumberInHH2013 = X2013_Census_number_of_usual_residents_in_household.1._for_households_in_occupied_private_dwellings_Mean_Number_of_Usual_Household_Members,
        
        PropMultiPersonHH2013 = X2013_Census_household_composition_for_households_in_occupied_private_dwellings_Other_multi.person_household /
            X2013_Census_household_composition_for_households_in_occupied_private_dwellings_Total_households_in_occupied_private_dwellings,
        
        PropInternetHH2013 = X2013_Census_access_to_telecommunications.20..21._for_households_in_occupied_private_dwellings_Access_to_the_Internet /
            X2013_Census_access_to_telecommunications.20..21._for_households_in_occupied_private_dwellings_Total_households_in_occupied_private_dwellings,
        
        PropNotOwnedHH2013 = X2013_Census_tenure_of_household.10._for_households_in_occupied_private_dwellings_Dwelling_Not_Owned_and_Not_Held_in_a_Family_Trust.12. /
            X2013_Census_tenure_of_household.10._for_households_in_occupied_private_dwellings_Total_households_in_occupied_private_dwellings,
        
        MedianRentHH2013 = X2013_Census_weekly_rent_paid_for_households_in_rented_occupied_private_dwellings.14._Median_Weekly_Rent_Paid_....16..18.,
        
        PropLandlordPublic2013 = (X2013_Census_sector_of_landlord_for_households_in_rented_occupied_private_dwellings.14._Housing_New_Zealand_Corporation +
                                  X2013_Census_sector_of_landlord_for_households_in_rented_occupied_private_dwellings.14._Local_Authority_or_City_Council +
                                  X2013_Census_sector_of_landlord_for_households_in_rented_occupied_private_dwellings.14._Other_State.Owned_Corporation_or_State.Owned_Enterprise_or_Government_Department_or_Ministry) /
                            X2013_Census_sector_of_landlord_for_households_in_rented_occupied_private_dwellings.14._Total_households_stated,
        
        PropNoMotorVehicle2013 = X2013_Census_number_of_motor_vehicles_for_households_in_occupied_private_dwellings_No_Motor_Vehicle / 
            X2013_Census_number_of_motor_vehicles_for_households_in_occupied_private_dwellings_Total_households_in_occupied_private_dwellings   
        ) %>%
    select(MB, NumberInHH2013, PropMultiPersonHH2013, PropInterneHH2013,
           PropNotOwnedHH2013, MedianRentHH2013, PropLandlordPublic2013,
           NoMotorVehicle2013)


#-----------------------finish-------------------
Meshblocks2013 <- dwelling %>%
    left_join(hh, by = "MB")
save(Meshblocks2013, file = "pkg/data/Meshblocks2013.rda")
     