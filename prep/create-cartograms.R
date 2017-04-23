

#============Regions=============
tmp <- REG

# note that Shapefiles seem to limit you to 
tmp@data <- REGC2013 %>%
    select(REGC2013_N, ResidentPop2013) %>%
    rename(REGC2014_N = REGC2013_N,
           RsPop2013= ResidentPop2013 )%>%
    right_join(REG@data, by = "REGC2013_N") %>%
    select(-SHAPE_Area, - SHAPE_Leng)

writeOGR(tmp, "tmp", layer = "regions", driver="ESRI Shapefile")

# Open ScapeToad and do the distortion in there with point-and-click

reg_cart <- readOGR("tmp", "reg-dist")

proj4string(reg_cart) <- proj4string(REG)
reg_cart <- spTransform(reg_cart, CRS("+init=epsg:4326"))

reg_cart@data <- reg_cart@data %>%
    select(-SHAPE_L, -SHAPE_A) %>%
    rename(Name = REGC2014_) %>%
    mutate(RsP2013 = as.numeric(as.character(RsP2013)))

par(fg = "white")
plot(reg_cart[1:16, ], col = 1:16)

save(reg_cart, file = "pkg2/data/reg_cart.rda")

# simplified version, with no Area Outside Region, and less space
reg_cart_simpl <- rmapshaper::ms_simplify(reg_cart[1:16, ])



save(reg_cart_simpl, file = "pkg2/data/reg_cart_simpl.rda")

#============Territorial Authorities=============
tmp <- TA

# note that Shapefiles seem to limit you to 
tmp@data <- TA2013 %>%
    select(TA2013_NAM, ResidentPop2013) %>%
    rename(TA2014_NAM = TA2013_NAM,
           RsPop2013= ResidentPop2013 )%>%
    right_join(TA@data, by = "TA2014_NAM") %>%
    select(-SHAPE_Area, - SHAPE_Leng)

writeOGR(tmp, "tmp", layer = "ta", driver="ESRI Shapefile")

# Open ScapeToad and do the distortion in there with point-and-click;
# save it as ta-dist

ta_cart <- readOGR("tmp", "ta-dist")

ta_cart@data <- ta_cart@data %>%
    rename(Name = TA2014_N)

par(fg = "white")
plot(ta_cart, col = 1:17)

save(ta_cart, file = "pkg2/data/ta_cart.rda")

# simplified version, with no Area Outside Region, and less space
ta_cart_simpl <- rmapshaper::ms_simplify(ta_cart[1:67, ])
save(ta_cart_simpl, file = "pkg2/data/ta_cart_simpl.rda")



