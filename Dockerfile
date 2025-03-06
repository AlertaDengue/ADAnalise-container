FROM rocker/tidyverse:latest

RUN apt-get update && apt-get install -y \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libgmp-dev \
  libmpfr-dev \
  libxt-dev \
  libopenblas-dev \
  libudunits2-dev \
  libgdal-dev \
  libgeos-dev \
  libproj-dev \
  gdal-bin \
  proj-bin \
  liblzma-dev \
  libxt-dev \
  libpng-dev \
  libtiff-dev \
  zlib1g-dev \
  libjpeg-dev \
  libicu-dev \
  gfortran \
  liblapack-dev \
  libatlas-base-dev \
  libnlopt-dev \
  make

RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >> "${R_HOME}/etc/Rprofile.site"

RUN R -e "install.packages('pak')"
RUN R -e "pak::pkg_install('ggplot2')"
RUN R -e "pak::pkg_install('foreign')"
RUN R -e "pak::pkg_install('tidyverse')"
RUN R -e "pak::pkg_install('forecast')"
RUN R -e "pak::pkg_install('RPostgreSQL')"
RUN R -e "pak::pkg_install('xtable')"
RUN R -e "pak::pkg_install('zoo')"
RUN R -e "pak::pkg_install('assertthat')"
RUN R -e "pak::pkg_install('DBI')"
RUN R -e "pak::pkg_install('devtools')"
RUN R -e "pak::pkg_install('lubridate')"
RUN R -e "pak::pkg_install('cgwtools')"
RUN R -e "pak::pkg_install('fs')"
RUN R -e "pak::pkg_install('brpop')"
RUN R -e "pak::pkg_install('argparse')"
RUN R -e "pak::pkg_install('futile.logger')"
RUN R -e "pak::pkg_install('units')"
RUN R -e "pak::pkg_install('sf')"
RUN R -e "pak::pkg_install('fmesher')"
RUN R -e "pak::pkg_install('miceadds')"
RUN R -e "pak::pkg_install('RPostgres')"
RUN R -e "pak::pkg_install('INLA')"
RUN R -e "pak::pkg_install('github::inlabru-org/fmesher')"
RUN R -e "pak::pkg_install('github::AlertaDengue/AlertTools')"

WORKDIR /app

COPY main.R ./

ENTRYPOINT ["Rscript", "main.R"]
