

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
#' @source \url{http://www.curia.co.nz/methodology/}
#' \url{http://www.pundit.co.nz/content/poll-of-polls}
#' @return a vector of weights, adding up to one, for use in calculating a weighted average of 
#' opinion polls
#' @examples
#' polldates <- tail(unique(polls$MidDate), 20)
#' pollweights(polldates, method = "curia")
#' pollweights(polldates, method = "pundit")
pollweights <- function(polldates, 
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
    


