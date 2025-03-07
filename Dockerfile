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

ARG UID=1000
ARG GID=1000
ENV R_LIBS_USER="/app/deps"

RUN mkdir -p $R_LIBS_USER && chown -R $UID:$GID /app

USER $UID

RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >> ~/.Rprofile

RUN R -e "install.packages('pak', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('ggplot2', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('foreign', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('tidyverse', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('cgwtools', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('fs', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('brpop', lib=Sys.getenv('R_LIBS_USER'))" 
RUN R -e "pak::pkg_install('argparse', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('futile.logger', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('units', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('sf', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('fmesher', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('miceadds', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('RPostgres', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "install.packages('INLA',repos=c(getOption('repos'), INLA='https://inla.r-inla-download.org/R/stable'), dep=TRUE, lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('github::inlabru-org/fmesher', lib=Sys.getenv('R_LIBS_USER'))"
RUN R -e "pak::pkg_install('github::AlertaDengue/AlertTools', lib=Sys.getenv('R_LIBS_USER'))"

WORKDIR /app

COPY --chown=$UID:$GID main.R ./

ENTRYPOINT ["Rscript", "main.R"]
