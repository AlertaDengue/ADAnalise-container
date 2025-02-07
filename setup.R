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
  "parallel",
  "cgwtools",
  "fs",
  "brpop",
  "argparse",
  "futile.logger",
  "units",
  "sf",
  "fmesher",
  "miceadds",
  "RPostgres"
)

options(error = traceback)

install <- function(pkg) {
  if (!nzchar(system.file(package = pkg))) {
    install.packages(pkg, dependencies = TRUE)
  }
}

lapply(cran, install)

if (!require("AlertTools")) {
  devtools::install_github("AlertaDengue/AlertTools", dependencies = TRUE)
}
