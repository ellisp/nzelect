#=====================polls pre 2020 election===================================
url <- "https://en.wikipedia.org/wiki/Opinion_polling_for_the_next_New_Zealand_general_election"

webpage <- url %>%
    read_html(encoding = "UTF-8") 

tabs <- webpage %>%
    html_nodes("table") 

# number below depends on the webpage...
tab <- html_table(tabs[[1]], fill = TRUE) 

# knock out the historical commentaries:
tab <- tab[tab[ , 2] != tab[ , 3], 1:12]

names(tab)[1] <- "WikipediaDates"

# tab[1]

tab$StartDate <- 
    as.Date(c("15/10/2018", "28/7/2018", "17/5/2018",
              "19/5/2018", "7/4/2018", "10/2/2018",
              "18/1/2018", "29/11/2017", "30/10/2017",
              "2/10/2017", "23/9/2017"), 
            format = "%d/%m/%Y")

tab$EndDate <- as.Date(c("19/10/2018", "1/8/2018", "24/5/2018",
                         "23/5/2018", "11/4/2018", "14/2/2018",
                         "28/1/2018", "5/12/2017", "12/11/2017",
                         "15/10/2017","23/9/2017"),
                       format = "%d/%m/%Y")

x <- names(tab)
names(tab) <- case_when(
    x == "NAT" ~ "National",
    x == "LAB" ~ "Labour",
    x == "NZF" ~ "NZ First",
    x == "GRN" ~ "Green",
    x == "MRI" ~ "Maori",
    x == "NCP" ~ "Conservative",
    x == "Polling organisation" ~ "Poll",
    TRUE ~ names(tab)
)

# we *should* collect sample size but for now it is a TODO
polls2020 <- tab[, !names(tab) %in% c("Sample size", "Lead")]



plyr::rbind.fill(polls2020, select(polls2008, Poll:National))
names(polls2008)
