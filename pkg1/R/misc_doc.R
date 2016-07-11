#' General Election Results 2014
#'
#' New Zealand 2014 general election results by voting place
#'
#' \itemize{
#'   \item \code{ApproxLocation}. Approximate location of voting place
#'   \item \code{VotingPlace}. Exact location of voting place
#'   \item \code{Party}. Party voted for (party vote) or party of candidate voted for
#'   (candidate vote)
#'   \item \code{Votes}. Number of votes
#'   \item \code{Electorate}. Electorate in which voters were enrolled.  Note that this 
#'   is not necessarily the physical location of the VotingPlace, so VotingPlace
#'   and Electorate have a many to many relationship
#'   \item \code{VotingType}. Party (proportional representation) or Candidate (first past 
#'   the vote).  In New Zealand each voter has to vote for both an individual
#'   candidate to represent their electorate, and a party vote for the overall makeup
#'   of Parliament.
#'   \item \code{Candidate}. If VotingType == "Candidate", the name of the candidate; 
#'   otherwise NA
#' }
#'
#' @format A data frame with 136,195 rows and 7 variables.
#' @source \url{http://www.electionresults.govt.nz/electionresults_2014/e9/html/statistics.html}
#' @seealso \code{\link{Locations2014}}
#' @examples
#' # the following matches the results published at
#' # http://www.electionresults.govt.nz/electionresults_2014/e9/html/e9_part1.html
#' library(tidyr)
#' library(dplyr)
#' GE2014 %>%
#'     mutate(VotingType = paste0(VotingType, "Vote")) %>%
#'     group_by(Party, VotingType) %>%
#'     summarise(Votes = sum(Votes)) %>%
#'     spread(VotingType, Votes) %>%
#'     select(Party, PartyVote, CandidateVote) %>%
#'     ungroup() %>%
#'     arrange(desc(PartyVote))
"GE2014"


#' General Election Voting Places 2014
#'
#' Voting places for the New Zealand 2014 general election 
#'
#' \itemize{
#'   \item \code{ElectorateNumber}
#'   \item \code{ElectorateName}.  Name of electorate in which the voting place is 
#'   physically located.
#'   \item \code{VotingPlaceID}.
#'   \item \code{NZTM2000Northing}
#'   \item \code{NZTM2000Easting}
#'   \item \code{WGS84Latitude}
#'   \item \code{WGS84Longitude}
#'   \item \code{VotingPlace}.  Address of the VotingPlace.  Cross-references to
#'    \code{GE2014$VotingPlace}.
#'   \item \code{TA2014_NAM}.  Name of the Territorial Authority in which the voting 
#'   place is physically located.
#'   \item \code{REGC2014_n}.  Name of the Regional Council in which the voting place is physically located.
#'   \item \code{AU2014}.  Number of the Area Unit in which the voting place is physically located.
#'   \item \code{MB2014}.  Number of the Mesh Block in which the voting place is physically located.
#' }
#'
#' @format A data frame with 2,568 rows and 9 variables.
#' @source \url{http://www.electionresults.govt.nz/electionresults_2014/e9/html/statistics.html} for the voting place locations.
#' \url{http://www.stats.govt.nz/browse_for_stats/Maps_and_geography/Geographic-areas/digital-boundary-files.aspx} 
#' for the 2014 shapefiles for Regional Council, Territorial Authority, and Area Unit.  See
#' \url{https://github.com/ellisp/nzelect/tree/master/prep} for the code linking the two.
#' @seealso \code{\link{GE2014}}
"Locations2014"



