FROM rocker/tidyverse:latest

RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >> "${R_HOME}/etc/Rprofile.site"

WORKDIR /app
COPY AlertaDengueAnalise/ ./

COPY dependencies.txt ./
RUN R -e "install.packages(readLines('dependencies.txt'), repos='http://cran.rstudio.com/')"

COPY setup.R ./
RUN Rscript setup.R

COPY main.R ./

ENTRYPOINT ["Rscript", "main.R"]
