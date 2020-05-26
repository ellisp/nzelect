

long_term_gdp_nz <- read_csv("downloads/other/LTD407301_20200526_015516_30.csv", skip = 1,
                          na = "..", col_types = cols()) %>%
    rename(year = X1) %>%
    filter(!is.na(year)) %>%
    gather(variable, value, -year) %>%
    filter(!is.na(value)) %>%
    arrange(year, variable)

save(long_term_gdp_nz, file = "pkg1/data/long_term_gdp_nz.rda")

