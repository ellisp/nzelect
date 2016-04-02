

# We want 2014 boundaries
download.file("http://www3.stats.govt.nz/digitalboundaries/annual/ESRI_Shapefile_Digital_Boundaries_2014_Generalised_12_Mile.zip",
              destfile = "downloads/shapefiles/2014_boundaries.zip", mode ="wb")

unzip("downloads/shapefiles/2014_boundaries.zip", exdir = "downloads/shapefiles")