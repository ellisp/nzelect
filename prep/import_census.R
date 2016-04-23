
# download.file("http://www3.stats.govt.nz/meshblock/2013/csv/2013_mb_dataset_Total_New_Zealand_CSV.zip",
#               destfile = "downloads/census2013/2013_mb_census.zip", mode = "wb")
# 
# unzip("downloads/census2013/2013_mb_census.zip", exdir = "downloads/census2013")



#-------------------selected dwellings variables-----------------
dwell_orig <- read.csv("downloads/census2013/2013-mb-dataset-Total-New-Zealand-Dwelling.csv",
                     stringsAsFactors = FALSE, na.strings = c("..C", "*"))


dwelling <- dwell_orig %>%
    rename(MB = Code, 
           MeanBedrooms2013 = X2013_Census_number_of_bedrooms_for_occupied_private_dwellings_Mean_Number_of_Bedrooms) %>%
    mutate(PropPrivateDwellings2013 = X2013_Census_dwelling_record_type_for_occupied_dwellings_Occupied_Private_Dwelling /
               X2013_Census_dwelling_record_type_for_occupied_dwellings_Total_occupied_dwellings,
           PropSeparateHouse2013 = X2013_Census_occupied_private_dwelling_type_Separate_House / 
               X2013_Census_occupied_private_dwelling_type_Total_occupied_private_dwellings
           ) %>%
    select(MB, Area_Code_and_Description, MeanBedrooms2013, PropPrivateDwellings2013, PropSeparateHouse2013)


#-------------------selected household variables--------------------
hh_orig <- read.csv("downloads/census2013/2013-mb-dataset-Total-New-Zealand-Household.csv",
                     stringsAsFactors = FALSE, na.strings = c("..C", "*"))

hh <- hh_orig %>%
    rename(MB = Code) %>%
    mutate(
        NumberInHH2013 = X2013_Census_number_of_usual_residents_in_household.1._for_households_in_occupied_private_dwellings_Mean_Number_of_Usual_Household_Members,
        
        PropMultiPersonHH2013 = X2013_Census_household_composition_for_households_in_occupied_private_dwellings_Other_multi.person_household /
            X2013_Census_household_composition_for_households_in_occupied_private_dwellings_Total_households_in_occupied_private_dwellings,
        
        PropInternetHH2013 = X2013_Census_access_to_telecommunications.20..21._for_households_in_occupied_private_dwellings_Access_to_the_Internet /
            X2013_Census_access_to_telecommunications.20..21._for_households_in_occupied_private_dwellings_Total_households_stated,
        
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
# names(indiv1_orig)[grep("X2013", names(indiv1_orig))]

indiv1 <- indiv1_orig %>%
    rename(MB = Code) %>%
    mutate(
        PropOld2013 = X2013_Census_age_in_broad_groups_for_the_census_usually_resident_population_count.1._65_years_and_Over / 
            X2013_Census_age_in_broad_groups_for_the_census_usually_resident_population_count.1._Total_people,
        PropEarly20s2013 = X2013_Census_age_in_five.year_groups_for_the_census_usually_resident_population_count.1._20.24_Years / 
            X2013_Census_age_in_five.year_groups_for_the_census_usually_resident_population_count.1._Total_people,
        PropAreChildren2013 = X2013_Census_age_in_broad_groups_for_the_census_usually_resident_population_count.1._Under_15_years /
            X2013_Census_age_in_broad_groups_for_the_census_usually_resident_population_count.1._Total_people,
        PropSameResidence5YearsAgo2013 = X2013_Census_usual_residence_five_years_ago_.2008._indicator_for_the_census_usually_resident_population_count.1._Same_as_Usual_Residence /
            X2013_Census_usual_residence_five_years_ago_.2008._indicator_for_the_census_usually_resident_population_count.1._Total_people,
        PropOverseas5YearsAgo2013 = X2013_Census_usual_residence_five_years_ago_.2008._indicator_for_the_census_usually_resident_population_count.1._Overseas /
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
    select(MB, PropOld2013, PropEarly20s2013, PropAreChildren2013, 
           PropSameResidence5YearsAgo2013, PropOverseas5YearsAgo2013, 
           PropNZBorn2013, PropEuropean2013, PropMaori2013, 
           PropPacific2013, PropAsian2013)

#------------selected individuals 2 variables-----------
indiv2_orig <- read.csv("downloads/census2013/2013-mb-dataset-Total-New-Zealand-Individual-Part-2.csv",
                        stringsAsFactors = FALSE, na.strings = c("..C", "*"))
# names(indiv2_orig)[grep("X2013", names(indiv2_orig))]

indiv2 <- indiv2_orig %>%
    rename(MB = Code) %>%
    mutate(
        PropNoReligion2013 = X2013_Census_religious_affiliation_.total_responses..2._for_the_census_usually_resident_population_count.1._No_Religion /
            X2013_Census_religious_affiliation_.total_responses..2._for_the_census_usually_resident_population_count.1._Total_people_stated,
        PropSmoker2013 = X2013_Census_cigarette_smoking_behaviour.4._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Regular_Smoker /
            X2013_Census_cigarette_smoking_behaviour.4._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people_stated,
        PropSeparated2013 = X2013_Census_legally_registered_relationship_status_for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Separated.divorced_or_dissolved.widowed.surviving_partner.6..7..8. /
            X2013_Census_legally_registered_relationship_status_for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people_stated,
        PropPartnered2013 = X2013_Census_partnership_status_in_current_relationship_for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Partnered /
            X2013_Census_partnership_status_in_current_relationship_for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people_stated,
        PropOwnResidence2013 = X2013_Census_tenure_holder.10._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Own_or_Partly_Own_Usual_Residence.11. /
            X2013_Census_tenure_holder.10._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people_stated,
        PropNoChildren2013 = X2013_Census_number_of_children_born_alive.13._for_the_female_census_usually_resident_population_count_aged_15_years_and_over.1._No_Children /
            X2013_Census_number_of_children_born_alive.13._for_the_female_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people_stated,
        PropNoQualification2013 = X2013_Census_highest_qualification.15._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._No_Qualification /
            X2013_Census_highest_qualification.15._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people_stated,
        PropBachelor2013 = X2013_Census_highest_qualification.15._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Bachelor_Degree_and_Level_7_Qualifications /
            X2013_Census_highest_qualification.15._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
        PropDoctorate2013 = X2013_Census_highest_qualification.15._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Doctorate_Degree /
            X2013_Census_highest_qualification.15._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people_stated,
        PropFTStudent2013 = X2013_Census_study_participation.18._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Full.time_Study.19. /
            X2013_Census_study_participation.18._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people_stated,
        PropPTStudent2013 = X2013_Census_study_participation.18._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Part.time_Study.20. /
            X2013_Census_study_participation.18._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people_stated,
        MedianIncome2013 = X2013_Census_total_personal_income_.grouped..21..22._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Median_personal_income_....23..27.,
        PropSelfEmployed2013 = X2013_Census_sources_of_personal_income.24..25..26._for_the_census_usually_resident_population_count_aged_15_years_and_over_Self.employment_or_Business /
            X2013_Census_sources_of_personal_income.24..25..26._for_the_census_usually_resident_population_count_aged_15_years_and_over_Total_people_Stated,
        PropUnemploymentBenefit2013 = X2013_Census_sources_of_personal_income.24..25..26._for_the_census_usually_resident_population_count_aged_15_years_and_over_Unemployment_Benefit /
            X2013_Census_sources_of_personal_income.24..25..26._for_the_census_usually_resident_population_count_aged_15_years_and_over_Total_people_Stated,
        PropStudentAllowance2013 = X2013_Census_sources_of_personal_income.24..25..26._for_the_census_usually_resident_population_count_aged_15_years_and_over_Student_Allowance /
            X2013_Census_sources_of_personal_income.24..25..26._for_the_census_usually_resident_population_count_aged_15_years_and_over_Total_people_Stated
    ) %>%
    select(MB, PropNoReligion2013, PropSmoker2013, PropSeparated2013, PropPartnered2013,
           PropOwnResidence2013, PropNoChildren2013, PropNoQualification2013, 
           PropBachelor2013, PropDoctorate2013, PropFTStudent2013,
           PropPTStudent2013, MedianIncome2013, PropSelfEmployed2013,
           PropUnemploymentBenefit2013, PropStudentAllowance2013)
        

#------------selected individuals 3a variables-----------
indiv3a_orig <- read.csv("downloads/census2013/2013-mb-dataset-Total-New-Zealand-Individual-Part-3a.csv",
                        stringsAsFactors = FALSE, na.strings = c("..C", "*"))
# names(indiv3a_orig)[grep("X2013", names(indiv3a_orig))]

indiv3a <- indiv3a_orig %>%
    rename(MB = Code) %>%
    mutate(PropFullTimeEmployed2013 = X2013_Census_work_and_labour_force_status.2._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Employed_Full.time /
               X2013_Census_work_and_labour_force_status.2._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropPartTimeEmployed2013= X2013_Census_work_and_labour_force_status.2._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Employed_Part.time /
               X2013_Census_work_and_labour_force_status.2._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropUnemployed2013 = X2013_Census_work_and_labour_force_status.2._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Unemployed /
               X2013_Census_work_and_labour_force_status.2._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropEmployee2013 = X2013_Census_status_in_employment.3..4._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Paid_Employee /
               X2013_Census_status_in_employment.3..4._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropEmployer2013 = X2013_Census_status_in_employment.3..4._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Employer /
               X2013_Census_status_in_employment.3..4._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropSelfEmployedNoEmployees2013 = X2013_Census_status_in_employment.3..4._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Self.Employed_and_Without_Employees /
               X2013_Census_status_in_employment.3..4._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropManagers2013 = X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Managers /
               X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropProfessionals2013 = X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Professionals /
               X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropTrades2013 = X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Technicians_and_Trades_Workers /
               X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropLabourers2013 = X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Labourers /
               X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropAgForFish2013 = X2013_Census_industry_.ANZSIC06_division..15..16._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Agriculture_Forestry_and_Fishing /
               X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropPubAdmin2013 = X2013_Census_industry_.ANZSIC06_division..15..16._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Public_Administration_and_Safety /
               X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropFinServices2013 = X2013_Census_industry_.ANZSIC06_division..15..16._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Financial_and_Insurance_Services /
               X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
           PropProfServices2013 = X2013_Census_industry_.ANZSIC06_division..15..16._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Professional_Scientific_and_Technical_Services /
               X2013_Census_occupation_.ANZSCO_major_group..6..7._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people
    ) %>%
    select(MB, PropFullTimeEmployed2013, PropPartTimeEmployed2013,
           PropUnemployed2013, PropEmployee2013, PropEmployer2013,
           PropSelfEmployedNoEmployees2013, PropManagers2013,
           PropProfessionals2013, PropTrades2013, PropLabourers2013,
           PropAgForFish2013, PropPubAdmin2013, PropFinServices2013,
           PropProfServices2013)
           
        
#------------selected individuals 3b variables-----------
indiv3b_orig <- read.csv("downloads/census2013/2013-mb-dataset-Total-New-Zealand-Individual-Part-3b.csv",
                         stringsAsFactors = FALSE, na.strings = c("..C", "*"))
# names(indiv3b_orig)[grep("X2013", names(indiv3b_orig))]

indiv3b <- indiv3b_orig %>%
    rename(MB = Code) %>%
    mutate(
        PropWorked40_49hours2013 = X2013_Census_hours_worked_in_employment_per_week.2..3._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._40.49_Hours_Worked /
            X2013_Census_hours_worked_in_employment_per_week.2..3._for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
        PropWorkedHome2013 = X2013_Census_main_means_of_travel_to_work_for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Worked_at_Home /
            X2013_Census_main_means_of_travel_to_work_for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
        PropPublicTransport2013 = (
            X2013_Census_main_means_of_travel_to_work_for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Public_Bus +
                X2013_Census_main_means_of_travel_to_work_for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Train
        ) /
            X2013_Census_main_means_of_travel_to_work_for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
        PropWalkJogBike2013 = (
            X2013_Census_main_means_of_travel_to_work_for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Bicycle +
                X2013_Census_main_means_of_travel_to_work_for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Walked_or_Jogged
        ) /
            X2013_Census_main_means_of_travel_to_work_for_the_employed_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people,
        PropNoUnpaidActivities2013 = X2013_Census_unpaid_activities.8..9._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._No_Activities /
            X2013_Census_unpaid_activities.8..9._for_the_census_usually_resident_population_count_aged_15_years_and_over.1._Total_people
    ) %>%
    select(MB, PropWorked40_49hours2013, PropWorkedHome2013,
           PropPublicTransport2013, PropWalkJogBike2013,
           PropNoUnpaidActivities2013)
               

#-----------------------finish-------------------
Combined <- dwelling %>%
    left_join(hh, by = "MB") %>%
    left_join(indiv1, by = "MB") %>%
    left_join(indiv2, by = "MB") %>%
    left_join(indiv3a, by = "MB") %>%
    left_join(indiv3b, by = "MB")

# Note - some proportions are > 1.0.  This is because of random rounding.
# Best to leave them in or else biases are introduced

Meshblocks2013 <- Combined %>%
    filter(substring(Area_Code_and_Description, 1, 2) == "MB")  %>%
    select(-Area_Code_and_Description)
    
save(Meshblocks2013, file = "pkg/data/Meshblocks2013.rda", compress = "xz")
     