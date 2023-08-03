# Base image https://hub.docker.com/u/rocker/
#FROM rocker/r-base:latest
FROM rocker/r-ver:4.0.1

## create directories
RUN mkdir -p /data /output

# Install package dplyr
RUN install2.r --error dplyr

#WORKDIR /home/student/mydocker2

## copy files
COPY /myScript.R /myScript.R


## install R-script
# CMD ["Rscript", "myScript.R"]

## install R-packages
RUN Rscript /myScript.R
