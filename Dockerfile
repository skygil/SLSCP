FROM r-base:latest

ARG WHEN

## create directories
RUN mkdir -p /data
RUN mkdir -p /output

# Install package dplyr
RUN install2.r --error dplyr

# Set Working Directory
WORKDIR /home/SLSCP

## copy files
COPY /myScript.R /myScript.R
COPY /data/plans.csv /data/plans.csv
COPY /data/slcsp.csv /data/slcsp.csv
COPY /data/zips.csv /data/zips.csv
COPY /output /output

## run the script
CMD R -e "source('/myScript.R')"
