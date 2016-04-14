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
#' @source \link{http://www.electionresults.govt.nz/electionresults_2014/e9/html/statistics.html}
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
#'   \item \code{AU2014_NAM}.  Number of the Area Unit in which the voting place is physically located.
#'   \item \code{MB2014}.  Number of the Mesh Block in which the voting place is physically located.
#' }
#'
#' @format A data frame with 2,568 rows and 9 variables.
#' @source \link{http://www.electionresults.govt.nz/electionresults_2014/e9/html/statistics.html} for the voting place locations.
#' \link{http://www.stats.govt.nz/browse_for_stats/Maps_and_geography/Geographic-areas/digital-boundary-files.aspx} 
#' for the 2014 shapefiles for Regional Council, Territorial Authority, and Area Unit.  See
#' \link{https://github.com/ellisp/nzelect/tree/master/prep} for the code linking the two.
#' @seealso \code{\link{GE2014}}
"Locations2014"



#' Census results by meshblock 2013
#'
#' Selected variables from the New Zealand 2013 census results by meshblock
#'
#' \itemize{
#'   \item \code{MB}. Meshblock code
#'   \item \code{MeanBedrooms2013}. Mean number of bedrooms per dwelling. 
#'   \item \code{PropPrivateDwellings2013}. Proportion of dwellings that are private
#'   dwellings.  
#'   \item \code{PropSeparateHouse2013}. Proportion of occupied private dwellings
#'   that are a separate house (as opposed to appartments, two or more houses, etc)
#'   \item \code{NumberInHH2013} Mean usual number of residents in households
#'   for private dwellings.
#'   \item \code{PropMultiPersonHH2013} Proportion of occupied private dwellings
#'    that are 'other multi person household' ie not a single person and not one
#'    or more families
#'   \item \code{PropInternetHH2013} Proportion of occupied private dwellings
#'   that have access to the internet
#'   \item \code{PropNotOwnedHH2013} Proportion of occupied private dwellings 
#'   that are not owned or held in private trust for the occupiers
#'   \item \code{MedianRentHH2013} Median weekly rent for rented occupied private dwellings
#'   \item \code{PropLandlordPublic2013} Proportion of rented occupied private dwellings
#'   where the landlord is one of Housing New Zealand, Local Authority, City Council,
#'   or other state-owned corporation or enterprise
#'   \item \code{PropNoMotorVehicle2013} Proportion of occupied private dwellings 
#'   that have no motor vehicle for the household
#'   \item \code{PropOld2013} Proportion of individuals aged 65 and over years
#'   \item \code{PropEarly20s2013} Proportion of individuals aged 20-24 years
#'   \item \code{PropAreChildren2013} Proportion of individuals aged under 15 years
#'   \item \code{PropSameResidence5YearsAgo2013} Proportion of individuals who
#'   lived in the same residence 5 years ago
#'   \item \code{PropOverseas5YearsAgo2013} Proportion of individuals who lived
#'   overseas 5 years ago
#'   \item \code{PropNZBorn2013} Proportion of individuals who were born in New
#'   Zealand
#'   \item \code{PropEuropean2013} Proportion of individuals with European ethnic group
#'   \item \code{PropMaori2013} Proportion of individuals with Maori ethnic group
#'   \item \code{PropPacific2013} Proportion of individuals with Pacific Peoples ethnic group
#'   \item \code{PropAsian2013} Proportion of individuals with Asiam ethnic group
#'   \item \code{PropNoReligion2013} Proportion of individuals who stated a religion
#'   with no religion   
#'   \item \code{PropSmoker2013} Proportion of individuals who stated smoking behaviour
#'   who smoked   
#'   \item \code{PropPartnered2013} Proportion of individuals who stated their status
#'   who had a partner
#'   \item \code{PropOwnResidence2013} Proportion of individuals who stated their status
#'   who were owner or part-owner of their residence
#'   \item \code{PropNoChildren2013} Proportion of individuals who stated their status
#'   who had no children
#'   \item \code{PropNoQualification2013} Proportion of individuals who stated their status
#'   with no educational qualification
#'   \item \code{PropBachelor2013} Proportion of individuals who stated their status
#'   whose highest qualification is a Bachelor degree
#'   \item \code{PropDoctorate2013} Proportion of individuals who stated their status
#'   whose highest qualification is a Doctorate
#'   \item \code{PropFTStudent2013} Proportion of individuals who stated their status
#'   who are in full time study
#'   \item \code{PropPTStudent2013} Proportion of individuals who stated their status
#'   who are in part time study
#'   \item \code{MedianIncome2013} Median individual income
#'   \item \code{PropSelfEmployed2013} Proportion of individuals who stated their status
#'   who received income from being self-employed or business
#'   \item \code{PropUnemploymentBenefit2013} Proportion of individuals who stated their status
#'   who received income from unemployment benefits
#'   \item \code{PropStudentAllowance2013} Proportion of individuals who stated their status
#'   who received income from student allowance
#' }
#'
#' Note that many values are NA due to confidentialisation.  And even the values
#' that appear to be numbers have been calculated from values that were random-rounded,
#' hence some results are odd (eg proportions greater than one).
#' @format A data frame with 46,629 rows and 35 variables.
#' @source \link{http://www3.stats.govt.nz/meshblock/2013/csv/2013_mb_dataset_Total_New_Zealand_CSV.zip}
#' @seealso \code{\link{Locations2014}}
#' @examples
#' head(Meshblocks2013)
"Meshblocks2013"