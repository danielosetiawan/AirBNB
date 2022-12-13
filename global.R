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
# reviews_df = read.fst('./reviews.fst')
PRH_df = read.fst('./price_reviews_hosts.fst')
hosts_df = read.fst('./hosts.fst')
saturation_df = read.fst('./saturation.fst')
neighborhoods_df = read.fst('./top_neighborhoods.fst')
neighborhoods_df2 = read.fst('./top_neighborhoods2.fst')

airbnb_red = 'FC642D'
airbnb_green = '00A699'


sass(
  sass_file("styles/main.scss"),
  output = "www/main.css",
  options = sass_options(output_style = "compressed"),
  cache = NULL
)