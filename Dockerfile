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

WORKDIR /app

COPY setup.R ./
RUN Rscript setup.R

COPY dependencies.txt ./
RUN R -e "options(error = traceback); install.packages(readLines('dependencies.txt'), repos='http://cran.rstudio.com/')"

RUN R -e "options(error = traceback); install.packages('units', repos='https://cloud.r-project.org')"
RUN R -e "options(error = traceback); install.packages('sf', repos='https://cloud.r-project.org')"

RUN R -e 'options(error = traceback); install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)'

RUN R -e 'options(error = traceback); utils::install.packages("miceadds")'
RUN R -e "options(error = traceback); remotes::install_github('inlabru-org/fmesher', ref = 'stable')"

COPY main.R ./

ENTRYPOINT ["Rscript", "main.R"]
