# AirBNB RProject

library(shiny)
library(DT)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(ggthemes)
library(tidyverse)
library(fst)

listings_df = read.fst('./listings.fst')
reviews_df = read.fst('./reviews.fst')
airbnb_red = 'FC642D'
airbnb_green = '00A699'

