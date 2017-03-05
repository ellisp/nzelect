
test_that("Seats allocation formula works", {

    # From Wikipedia; should return 3, 2, 2:
     expect_equal(
         allocate_seats(c(53000, 24000, 23000), nseats = 7, threshold = 0)$seats_v,
         c(3,2,2)
         )
        
    # From 2014 New Zealand election
    votes <- c(National = 1131501, Labour = 604535, Green = 257359,
            NZFirst = 208300, Cons = 95598, IntMana = 34094, 
            Maori = 31849, Act = 16689, United = 5286,
            Other = 20411)
    electorate = c(41, 27, 0, 
                0, 0, 0, 
                1, 1, 1,
                0)
                    
    # Actual result:               
     expect_equal(
         as.vector(allocate_seats(votes, electorate = electorate)$seats_v),
         c(60, 32, 14, 
           11, 0, 0,
           2, 1, 1,
           0)
     )
     
})