#' General Election Results 2014
#'
#' New Zealand 2014 general election results by voting place
#'
#' \itemize{
#'   \item ApproxLocation. Approximate location of voting place
#'   \item VotingPlace. Exact location of voting place
#'   \item Party. Party voted for (party vote) or party of candidate voted for
#'   (candidate vote)
#'   \item Votes. Number of votes
#'   \item Electorate. Electorate in which voters were enrolled.  Note that this 
#'   is not necessarily the physical location of the VotingPlace, so VotingPlace
#'   and Electorate have a many to many relationship
#'   \item VotingType. Party (proportional representation) or Candidate (first past 
#'   the vote).  In New Zealand each voter has to vote for both an individual
#'   candidate to represent their electorate, and a party vote for the overall makeup
#'   of Parliament.
#'   \item Candidate. If VotingType == "Candidate", the name of the candidate; 
#'   otherwise NA
#' }
#'
#' @format A data frame with 136,195 rows and 7 variables.
#' @source \link{http://www.electionresults.govt.nz/electionresults_2014/e9/html/statistics.html}
#' @seealso \code{\link{Locations2014}}
"GE2014"



#' General Election Voting Places 2014
#'
#' Voting places for the New Zealand 2014 general election 
#'
#' \itemize{
#'   \item ElectorateNumber.
#'   \item ElectorateName.  Name of electorate in which the voting place is 
#'   physically located.
#'   \item VotingPlaceID.
#'   \item NZTM2000Northing
#'   \item NZTM2000Easting
#'   \item WGS84Latitude
#'   \item WGS84Longitude
#'   \item VotingPlace.  Address of the VotingPlace.  Cross-references to
#'    GE2014$VotingPlace.
#' }
#'
#' @format A data frame with 2,568 rows and 9 variables.
#' @source \link{http://www.electionresults.govt.nz/electionresults_2014/e9/html/statistics.html}
#' @seealso \code{\link{GE2014}}
"Locations2014"