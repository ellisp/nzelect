
download.file("http://www3.stats.govt.nz/meshblock/2013/csv/2013_mb_dataset_Total_New_Zealand_CSV.zip",
              destfile = "downloads/census2013/2013_mb_census.zip", mode = "wb")

unzip("downloads/census2013/2013_mb_census.zip", exdir = "downloads/census2013")


