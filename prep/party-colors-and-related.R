

url <- "https://en.wikipedia.org/wiki/Wikipedia:Index_of_New_Zealand_political_party_meta_attributes"

parties_orig <- url %>%
    read_html(encoding = "UTF-8") 

tabs <- parties_orig %>%
    html_nodes("table") 

tabs2 <- lapply(tabs, html_table, fill = TRUE)


parties_df <- tabs2[[1]] %>%
    rbind(tabs2[[2]]) %>%
    select(2:5) %>%
    rbind(tabs2[[3]][ , -1]) %>%
    filter(substring(Shading, 1, 1) == "#") %>%
    rbind(data_frame(Shortname = "Progressive",
                     Colour = "#9E9E9E",
                     Article = "Jim Anderton's Progressive Party",
                     Shading = "#DDCCDD")) %>%
    rbind(data_frame(Shortname = "Destiny",
                     Colour = "#FFFF00",
                     Article = "Destiny New Zealand",
                     Shading = "000000")) %>%
    rbind(data_frame(Shortname = "TOP",
                     Colour = "#FF4040",
                     Article = "The Opportunities Party",
                     Shading = "000000")) %>%
    rename(Longname = Article)


parties_v <- parties_df$Colour
names(parties_v) <- parties_df$Shortname


save(parties_v, file = "pkg1/data/parties_v.rda")
save(parties_df, file = "pkg1/data/parties_df.rda")
