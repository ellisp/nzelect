#' General Election Voting Places 2008 and onwards
#'
#' Voting places for the New Zealand general elections in 2008, 2011 and 2014 
#'
#' \itemize{
#'   \item \code{electorate_number}
#'   \item \code{electorate}.  Name of electorate in which the voting place is 
#'   physically located.
#'   \item \code{voting_place_suburb}
#'   \item \code{northing} Coordinates, on one of two incompatible systems - either NZTM2000 or NZMG - 
#'   see the \code{coordinate_system} variable for which.
#'   \item \code{easting} as per \code{northing}
#'   \item \code{longitude} Use with caution.
#'   \item \code{latitude} Use with caution.
#'   \item \code{type} 'Advance' or 'Election Day' (2017 only; NA otherwise)
#'   \item \code{voting_place}.  Address of the VotingPlace.  Cross-references to
#'    \code{nzge$voting_place}.
#'    \item \code{election_year}.  Year in which this was a voting place for the election.
#'    \item \code{coordinate_system}.  Either NZMG (New Zealand Map Grid) or NZTM2000 (New Zealand Transverse 
#'    Mercator Projection)
#'   \item \code{TA2014_NAM}.  Name of the Territorial Authority in which the voting 
#'   place is physically located.  Use with caution.
#'   \item \code{REGC2014_n}.  Name of the Regional Council in which the voting place is physically located. Use with caution.
#'   \item \code{AU2014}.  Number of the Area Unit in which the voting place is physically located.  Use with caution.
#'   \item \code{MB2014}.  Number of the Mesh Block in which the voting place is physically located. Use with caution.
#' }
#'
#' @format A data frame with 10,774 rows and 15 variables.
#' @details There are problems with the locations of many voting places which will be resolved in future versions.
#' @source \url{http://www.electionresults.govt.nz/electionresults_2014/e9/html/statistics.html} (and similar for earlier years) 
#' for the voting place locations.
#' \url{http://www.stats.govt.nz/browse_for_stats/Maps_and_geography/Geographic-areas/digital-boundary-files.aspx} 
#' for the 2014 shapefiles for Regional Council, Territorial Authority, and Area Unit.  See
#' \url{https://github.com/ellisp/nzelect/tree/master/prep} for the code linking the two.
#' @seealso \code{\link{nzge}}
"voting_places"

#' General Election Results 2002 and onwards
#'
#' New Zealand general election results by voting place for 2002, 2005, 2008, 2011 and 2014
#'
#' \itemize{
#'   \item \code{approx_location}. Approximate location of voting place
#'   \item \code{vorting_place}. Description of exact location of voting place
#'   \item \code{party}. Party voted for (party vote) or party of candidate voted for
#'   (candidate vote)
#'   \item \code{votes}. Number of votes
#'   \item \code{electorate}. Electorate in which voters were enrolled.  Note that this 
#'   is not necessarily the physical location of the voting_place, so voting_place
#'   and electorate have a many to many relationship
#'   \item \code{voting_type}. Party (proportional representation) or Candidate (first past 
#'   the vote).  In New Zealand each voter has to vote for both an individual
#'   candidate to represent their electorate, and a party vote for the overall makeup
#'   of Parliament.
#'   \item \code{candidate}. If voting_type == "Candidate", the name of the candidate; 
#'   otherwise NA
#'   \item \code{election_year}.  Year of the election.
#'   \item \code{electorate_number}.  Number of the electorate.
#' }
#'
#' @format A data frame with 900,531 rows and 9 variables.
#' @source \url{http://www.electionresults.govt.nz/electionresults_2014/e9/html/statistics.html}
#' @seealso \code{\link{voting_places}}
#' @examples
#' # the following matches the results published at
#' # http://www.electionresults.govt.nz/electionresults_2014/e9/html/e9_part1.html
#' library(tidyr)
#' library(dplyr)
#' nzge %>%
#'     mutate(voting_type = paste0(voting_type, " vote")) %>%
#'     group_by(party, voting_type, election_year) %>%
#'     summarise(votes = sum(votes)) %>%
#'     spread(voting_type, votes) %>%
#'     ungroup() %>%
#'     arrange(election_year, desc(`Party vote`))
"nzge"