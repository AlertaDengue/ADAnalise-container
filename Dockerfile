FROM rocker/tidyverse:latest
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >>"${R_HOME}/etc/Rprofile.site"

COPY . /app
WORKDIR /app

# Copy the dependencies file and the R script into the container
COPY dependencies.txt setup.R ./
COPY your_script.R .

# Install the R package dependencies
RUN R -e "install.packages(readLines('dependencies.txt'), repos='http://cran.rstudio.com/')"
RUN Rscript setup.R

# Command to run the R script
ENTRYPOINT ["Rscript", "your_script.R"]
