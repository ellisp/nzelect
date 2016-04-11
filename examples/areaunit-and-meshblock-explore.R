library(nzelect)
head(GE2014)
?GE2014

head(Locations2014)

mbcount <- as.numeric(table(unique(Locations2014[, c("VotingPlace", "MB2014")])$MB2014))
table(mbcount) # 18 meshblocks have 2 voting places

aucount <- as.numeric(table(unique(Locations2014[, c("VotingPlace", "AU2014")])$AU2014))
table(aucount) # 406 meshblocks have 2 voting places, 10 have 7 and one even has 10
