#' New Zealand political party colours
#'
#' Colours associated with New Zealand political parties in the early 21st century
#'
#' @format A named vector of colours
#' @source \url{https://en.wikipedia.org/wiki/Wikipedia:Index_of_New_Zealand_political_party_meta_attributes}
"parties_v"

#' New Zealand political parties
#'
#' Metadata associated with New Zealand political parties in the early 21st century
#'
#' @format A data frame of colours, shades, short and long names
#' @source \url{https://en.wikipedia.org/wiki/Wikipedia:Index_of_New_Zealand_political_party_meta_attributes}
"parties_df"

#' New Zealand Opinion Polls
#'
#' Opinion polling of voting intention for New Zealand general elections
#' 
#' Intended party vote.  Note the original source says 'Refusals are generally 
#' excluded from the party vote percentages, while question wording and the 
#' treatment of "don't know" responses and those not intending to vote may vary 
#' between survey organisations.'
#' 
#' \code{EndData} and \code{StartDate} refer to the data collection period.  These
#' dates were entered by hand, use with caution and check against \code{WikipediaDates} 
#' which is the version from the original source.
#' 
#' Where the date in Wikipedia is given only as "released on X", the start and end dates
#' have been deemed to be two days before release.
#'
#' @format A data frame of 7 columns
#' @source \url{https://en.wikipedia.org/wiki/Opinion_polling_for_the_New_Zealand_general_election,_2014}
#' \url{https://en.wikipedia.org/wiki/Opinion_polling_for_the_New_Zealand_general_election,_2017}
"polls"