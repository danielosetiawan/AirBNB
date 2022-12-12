# AirBNB RProject

library(DT)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(tidyverse)
library(fst)
library(sass)
library(htmltools)


listings_df = read.fst('./listings.fst')
reviews_df = read.fst('./reviews.fst')
neighborhoods_df = read.fst('./top_neighborhoods.fst')
airbnb_red = 'FC642D'
airbnb_green = '00A699'


sass(
  sass_file("styles/main.scss"),
  output = "www/main.css",
  options = sass_options(output_style = "compressed"),
  cache = NULL
)