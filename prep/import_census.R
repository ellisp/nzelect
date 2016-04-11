
# download.file("http://www3.stats.govt.nz/meshblock/2013/csv/2013_mb_dataset_Total_New_Zealand_CSV.zip",
#               destfile = "downloads/census2013/2013_mb_census.zip", mode = "wb")
# 
# unzip("downloads/census2013/2013_mb_census.zip", exdir = "downloads/census2013")



#-------------------selected dwellings variables-----------------
tmp_orig <- read.csv("downloads/census2013/2013-mb-dataset-Total-New-Zealand-Dwelling.csv",
                     stringsAsFactors = FALSE, na.strings = c("..C", "*"))


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
                     stringsAsFactors = FALSE, na.strings = c("..C", "*"))

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
    select(MB, NumberInHH2013, PropMultiPersonHH2013, PropInternetHH2013,
           PropNotOwnedHH2013, MedianRentHH2013, PropLandlordPublic2013,
           PropNoMotorVehicle2013)


#------------selected individuals 1 variables-----------
indiv1_orig <- read.csv("downloads/census2013/2013-mb-dataset-Total-New-Zealand-Individual-Part-1.csv",
                        stringsAsFactors = FALSE, na.strings = c("..C", "*"))
names(indiv1_orig)[grep("X2013", names(indiv1_orig))]

indiv1 <- indiv1_orig %>%
    rename(MB = Code) %>%
    mutate(
        PropOld2013 = X2013_Census_age_in_broad_groups_for_the_census_usually_resident_population_count.1._65_years_and_Over / 
            X2013_Census_age_in_broad_groups_for_the_census_usually_resident_population_count.1._Total_people,
        PropEarly20s2013 = X2013_Census_age_in_five.year_groups_for_the_census_usually_resident_population_count.1._20.24_Years / 
            X2013_Census_age_in_five.year_groups_for_the_census_usually_resident_population_count.1._Total_people,
        PropChildren2013 = X2013_Census_age_in_broad_groups_for_the_census_usually_resident_population_count.1._Under_15_years /
            X2013_Census_age_in_broad_groups_for_the_census_usually_resident_population_count.1._Total_people,
        PropSameResidence2013 = X2013_Census_usual_residence_five_years_ago_.2008._indicator_for_the_census_usually_resident_population_count.1._Same_as_Usual_Residence /
            X2013_Census_usual_residence_five_years_ago_.2008._indicator_for_the_census_usually_resident_population_count.1._Total_people,
        PropOverseas2013 = X2013_Census_usual_residence_five_years_ago_.2008._indicator_for_the_census_usually_resident_population_count.1._Overseas /
            X2013_Census_usual_residence_five_years_ago_.2008._indicator_for_the_census_usually_resident_population_count.1._Total_people,
        PropNZBorn2013 = X2013_Census_birthplace_for_the_census_usually_resident_population_count.1._NZ_born /
            X2013_Census_birthplace_for_the_census_usually_resident_population_count.1._Total_people,
        PropEuropean2013 = X2013_Census_ethnic_group_.grouped_total_responses..7..8._for_the_census_usually_resident_population_count.1._European /
            X2013_Census_ethnic_group_.grouped_total_responses..7..8._for_the_census_usually_resident_population_count.1._Total_people,
        PropMaori2013 = X2013_Census_ethnic_group_.grouped_total_responses..7..8._for_the_census_usually_resident_population_count.1._Maori /
            X2013_Census_ethnic_group_.grouped_total_responses..7..8._for_the_census_usually_resident_population_count.1._Total_people,
        PropPacific2013 = X2013_Census_ethnic_group_.grouped_total_responses..7..8._for_the_census_usually_resident_population_count.1._Pacific_Peoples /
            X2013_Census_ethnic_group_.grouped_total_responses..7..8._for_the_census_usually_resident_population_count.1._Total_people,
        PropAsian2013 = X2013_Census_ethnic_group_.grouped_total_responses..7..8._for_the_census_usually_resident_population_count.1._Asian /
            X2013_Census_ethnic_group_.grouped_total_responses..7..8._for_the_census_usually_resident_population_count.1._Total_people
     ) %>%
    select(MB, PropOld2013, PropEarly20s2013, PropChildren2013, PropSameResidence2013,
           PropOverseas2013, PropNZBorn2013, PropEuropean2013, PropMaori2013, 
           PropPacific2013, PropAsian2013)

#-----------------------finish-------------------
Meshblocks2013 <- dwelling %>%
    left_join(hh, by = "MB") %>%
    left_join(indiv1, by = "MB")
save(Meshblocks2013, file = "pkg/data/Meshblocks2013.rda")
     