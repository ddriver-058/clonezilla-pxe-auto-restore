FROM rocker/tidyverse:4.4.0

RUN R -e 'install.packages("plumber")'