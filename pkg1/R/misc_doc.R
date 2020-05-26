#' Distinct voting places
#' 
#' De-duplicated voting places from 2008 to 2017 with unique IDs allocated to them
#' 
#' The locations listed in the Electoral Commissions' various lists of voting places have been matched 
#' for likely duplicates and unique ids assigned to them.  
#' 
#' @format A data frame with 3,425 rows and 8 columns
#' 
#' @source \url{http://www.electionresults.govt.nz/electionresults_2014/e9/html/statistics.html} (and similar for earlier years) 
#' for the voting place locations.
#' \url{http://www.stats.govt.nz/browse_for_stats/Maps_and_geography/Geographic-areas/digital-boundary-files.aspx} 
#' for the 2014 shapefiles for Regional Council, Territorial Authority, and Area Unit.  See
#' \url{https://github.com/ellisp/nzelect/tree/master/prep} for the code linking the two.
#' @seealso \code{\link{nzge}}
"distinct_voting_places"


#' General Election Results 2002 and onwards
#'
#' New Zealand general election results by voting place for 2002, 2005, 2008, 2011 and 2014
#'
#'#' \itemize{
#'   \item \code{approx_location}. Approximate location of voting place
#'   \item \code{voting_place}. Description of exact location of voting place
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
#' @seealso \code{\link{distinct_voting_places}}
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



#' Estimates of long term GDP
#'
#' Seven different estimates of long term GDP in New Zealand
#'
#' @details The seven different values of variable are: 
#'
#'
#'\itemize{
#'   \item Rankin (1990) - GNP, 1910/11 prices, calendar year           
#'   \item Greasley and Oxley (2008) - index, 1939 = 100"                
#'   \item Easton (1997) - 1977/79 prices"                               
#'   \item SNA - Statistics New Zealand official series - 1977/78 prices
#'   \item SNB - Statistics New Zealand official series - 1991/92 prices
#'   \item SND - Statistics New Zealand official series - 1995/96 prices
#'   \item SNC - Statistics New Zealand official series - 1995/96 prices
#' }
#'
#' @format A data frame with 333 rows and d variables.
#' @source Stats NZ Infoshare
"long_term_gdp_nz"