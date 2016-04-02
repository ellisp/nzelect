library(knitr)
library(devtools)

document("pkg")
knit("README.Rmd", "README.md")

build("pkg")
