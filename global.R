#myApp2

library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(DT)

flights = read.csv(file = './flights14.csv')
