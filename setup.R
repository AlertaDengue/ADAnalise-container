cran <- c(
  "foreign",
  "tidyverse",
  "forecast",
  "RPostgreSQL",
  "xtable",
  "zoo",
  "assertthat",
  "DBI",
  "devtools",
  "lubridate",
  "grid",
  "INLA",
  "parallel",
  "cgwtools",
  "fs",
  "miceadds",
  "brpop",
  "argparse"
)

install <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

lapply(cran, install)

if (!require("AlertTools")) {
  devtools::install_github("AlertaDengue/AlertTools", dependencies = TRUE)
}
