

#' Weight polls
#' 
#' Create a vector of weights to use in calculating a weighted average
#' 
#' @export
#' @param polldates a vector of dates of polls
#' @param n a vector of sample sizes of polls
#' @param method which weighting method to use; either that used in 2017 by Curia or Pundit 
#' (two New Zealand poll aggregators)
#' @param refdate date against which to compare polling dates (both methods give more weight
#' to more recent polls)
#' @param electiondate date of the next election (the Curia weighting method gives more weight
#' to polls close to the election)
#' @details This function is to facilitate reproduction of existing poll aggregation methods.
#' 
#' Both methods provide weights proportional to the sample sizes.
#' 
#' The Pundit Poll of Polls states its method is an adaptation of that used by 
#' fivethirtyeight.  It gives polls a half life of 30 days, so a poll that is 
#' 120 days old gets 0.125 the weight of one conducted today.
#' 
#' The Curia method gives weight of 1 to all polls that are seven or less days old;
#' 0 to polls older than 38 days; and a linear interpolation for inbetween.  Note that
#' this method gives zero weight to many older surveys that would get a weight in the 
#' pundit method.
#' @references \url{http://www.curia.co.nz/methodology/}
#' \url{http://www.pundit.co.nz/content/poll-of-polls}
#' @return a vector of weights, adding up to one, for use in calculating a weighted average of 
#' opinion polls
#' @examples
#' polldates <- tail(unique(polls$MidDate), 20)
#' weight_polls(polldates, method = "curia")
#' weight_polls(polldates, method = "pundit")
weight_polls <- function(polldates, 
                        n = rep(1, length(polldates)),
                        method = c("pundit", "curia"),
                        refdate = Sys.Date(),
                        electiondate = as.Date("2017-09-23")){
    
    # check legit parameters:
    method <- match.arg(method)
    if(class(polldates) != "Date"){
        stop("polldates must be a vector of dates")
    }
    if(length(n) != length(polldates)){
        stop("n must be a vector of the same length as polldates")
    }
    if(max(polldates) > refdate){
        stop("All polldates need to be in the past relative to refdate")
    }
    
    ages <- as.numeric(refdate - polldates)
    
    if(method == "curia"){
        # deduced from http://www.curia.co.nz/methodology/
        w <- ifelse(ages > 38, 0, 
               ifelse(ages < 8, 1,
                      (38.5 - ages) / 30
                      ))
        w <- w * n
    } else {
        # method = pundit
        # deduced from http://www.pundit.co.nz/content/poll-of-polls
        if(max(polldates) > electiondate | refdate > electiondate){
            stop("All polls should have been before the election")
        }
        recency <- 1 / 2 ^ (ages / 30)
        recency <- (recency >= 0.05) * recency
        proximity <- 1 / as.numeric(electiondate - polldates)
        w <- recency * proximity * n
    }
    
    # scale so they add to 1:
    w <- w / sum(w)
    return(w)
}
    


#' Allocate seats after election
#' 
#' Allocates seats in Parliament after an election using the Sainte-Lague 
#' allocation formula
#' 
#' @export
#' @param parties vector of names of parties
#' @param votes vector of vote proportions or counts
#' @param nseats number of seats to allocate.  Note that in mixed systems such as New Zealand's
#' where \code{electorate} is not all zero, there may be a "hangover" and total number of seats
#' ends up larger than \code{nseats} due to parties that win an electorate seat but received less
#' than \code{1/nseats} of the vote.
#' @param threshold minimum proportion of votes needed to be allocated a seat
#' @param electorate a numeric vector of same length as parties.  If \code{>0},
#' the party is allocated seats regardless of whether the party exceeded \code{threshold}.
#' This is needed in a mixed-member proportional system such as New Zealand's.
#' @return a list with two elements: a data frame and a vector, each of which has a number
#' of seats allocated to each party.
#' @author Peter Ellis
#' @references  \url{http://www.elections.org.nz/voting-system/mmp-voting-system/sainte-lague-allocation-formula}   
#' \url{https://en.wikipedia.org/wiki/Webster/Sainte-Lagu\%C3\%AB_method}
#' @examples
#' 
#' # From Wikipedia; should return 3, 2, 2:
#' allocate_seats(c(53000, 24000, 23000), nseats = 7, threshold = 0)
#' 
#' # From 2014 New Zealand election
#' votes <- c(National = 1131501, Labour = 604535, Green = 257359,
#'            NZFirst = 208300, Cons = 95598, IntMana = 34094, 
#'            Maori = 31849, Act = 16689, United = 5286,
#'            Other = 20411)
#' electorate = c(41, 27, 0, 
#'                0, 0, 0, 
#'                1, 1, 1,
#'                0)
#'                
#' # Actual result:               
#' allocate_seats(votes, electorate = electorate)
#' 
#' # Result if there were no 5% minimum threshold:
#' allocate_seats(votes, electorate = electorate, threshold = 0)$seats_v
allocate_seats <- function(votes, parties = names(votes), 
                           nseats = 120, threshold = 0.05,
                           electorate = rep(0, length(votes))){
    
    # convert votes to a proportion:
    V <- votes / sum(votes) 
    
    # only give proportional-based votes to parties with threshold votes
    # or an electorate seat:
    V <- V * (electorate > 0 | V > threshold)
    
    s <- numeric(length(V))
    
    while(sum(s) < nseats){
        quot <- V / (2 * s + 1)
        top_party <- which(quot == max(quot))
        s[top_party] <- s[top_party] + 1
    }
    
    
    seats <- data.frame(proportionally_allocated = s, 
                        electorate_seats = electorate)
    seats$final <- apply(seats, 1, max)
    seats$party <- parties
    
    seats_v <- seats$final
    names(seats_v) <- parties
    
    return(list(seats_df = seats, seats_v = seats_v))
}

