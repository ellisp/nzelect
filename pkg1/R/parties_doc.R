#' New Zealand political party colours
#'
#' Colours associated with New Zealand political parties in the early 21st century
#'
#' @format A named vector of colours
#' @source \url{https://en.wikipedia.org/wiki/Wikipedia:Index_of_New_Zealand_political_party_meta_attributes}
#' @examples
#' # Example use of parties_v in a colour scale for ggplot2
#' if(require(ggplot2) & require(scales) & require(dplyr) & require(forcats)){
#' polls %>%
#' filter(MidDate > as.Date("2014-11-20") & !is.na(VotingIntention)) %>%
#'     mutate(Party = fct_reorder(Party, VotingIntention, .desc = TRUE),
#'            Party = fct_drop(Party)) %>%
#'     ggplot(aes(x = MidDate, y = VotingIntention, colour = Party, linetype = Pollster)) +
#'     geom_line(alpha = 0.5) +
#'     geom_point(aes(shape = Pollster)) +
#'     geom_smooth(aes(group = Party), se = FALSE, colour = "grey15", span = .4) +
#'     scale_colour_manual(values = parties_v) +
#'     scale_y_continuous("Voting intention", label = percent) +
#'     scale_x_date("") +
#'     facet_wrap(~Party, scales = "free_y") 
#'     }
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
#' dates were entered by hand, use with caution and check against the \code{WikipediaDates} 
#' column which is the version from the original source.
#' 
#' Where the date in Wikipedia is given only as "released on X", the start and end dates
#' have been deemed to be two days before release.
#' 
#' The data for the 2005 election are particularly unreliable and in some cases it is not 
#' clear whether some parties have been omitted.  For example, the Digipoll from 22 March 
#' to 30 March 2005 has figures only for National and Labour (47.5 and 34.5).
#'
#' @format A data frame of 7 columns
#' @source 
#' \url{https://en.wikipedia.org/wiki/Opinion_polling_for_the_New_Zealand_general_election,_2005}
#' \url{https://en.wikipedia.org/wiki/Opinion_polling_for_the_New_Zealand_general_election,_2008}
#' \url{https://en.wikipedia.org/wiki/Opinion_polling_for_the_New_Zealand_general_election,_2011}
#' \url{https://en.wikipedia.org/wiki/Opinion_polling_for_the_New_Zealand_general_election,_2014}
#' \url{https://en.wikipedia.org/wiki/Opinion_polling_for_the_New_Zealand_general_election,_2017}
#' @examples
#' if(require(ggplot2) & require(scales) & require(dplyr) & require(forcats)){
#' election_dates <- polls %>%
#'     filter(Pollster == "Election result") %>%
#'     select(MidDate) %>%
#'     distinct()
#' 
#' polls %>%
#'     mutate(Party = fct_reorder(Party, VotingIntention, .desc = TRUE),
#'            Pollster = fct_relevel(Pollster, "Election result")) %>%
#'     ggplot(aes(x = MidDate, y = VotingIntention, linetype = Pollster)) +
#'     geom_line(alpha = 0.5) +
#'     geom_point(aes(colour = Client), size = 0.7) +
#'     geom_smooth(aes(group = Party), se = FALSE, colour = "grey15", span = .20) +
#'     scale_y_continuous("Voting intention", label = percent) +
#'     scale_x_date("") +
#'     facet_wrap(~Party, scales = "free_y") +
#'     geom_vline(xintercept = as.numeric(election_dates$MidDate), colour = "grey80") 
#' }
"polls"