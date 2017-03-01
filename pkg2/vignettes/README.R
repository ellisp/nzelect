## ----fig.width = 7, fig.height = 7---------------------------------------
library(nzcensus)
library(ggrepel)
library(scales)
REGC2013$region <- gsub(" Region", "", REGC2013$REGC2013_N)

ggplot(REGC2013, aes(x = PropPubAdmin2013, y = PropPartnered2013, label = region) ) +
    geom_point() +
    geom_text_repel(colour = "steelblue") +
    scale_x_continuous("Proportion of workers in public administration", label = percent) +
    scale_y_continuous("Proportion of individuals who stated status that have partners", label = percent) +
    ggtitle("New Zealand census 2013")

## ----fig.width = 7, fig.height = 7---------------------------------------
ggplot(Meshblocks2013, aes(x = WGS84Longitude, y = WGS84Latitude, colour = MedianIncome2013)) +
    borders("nz", fill = terrain.colors(5)[3], colour = NA) +
    geom_point(alpha = 0.1) +
    coord_map(xlim = c(166, 179)) +
    ggthemes::theme_map() +
    ggtitle("Locations of centers of meshblocks in 2013 census") +
    scale_colour_gradientn(colours = c("blue", "white", "red"), label = dollar) +
    theme(legend.position = c(0.1, 0.6))


