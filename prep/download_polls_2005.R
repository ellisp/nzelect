url <- "https://en.wikipedia.org/wiki/Opinion_polling_for_the_New_Zealand_general_election,_2005"

webpage <- url %>%
    read_html(encoding = "UTF-8") 

tabs <- webpage %>%
    html_nodes("table") 

tab <- html_table(tabs[[1]], fill = TRUE) 

#View(tab)

tab <- tab[tab[ , 1] != tab[ , 2], ]
tab <- tab[tab[ , 1] != "Poll", ]
names(tab)[2] <- "WikipediaDates"

tab$WikipediaDates

tab$StartDate <- as.Date(c("27/7/2002", ),
                         format = "%d/%m/%Y")

tab$EndDate <- as.Date(c(), 
                       format = "%d/%m/%Y")

polls2005 <- tab
