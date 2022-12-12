# AirBNB RProject

library(shiny)
library(shinydashboard)
# library(shinyj)

# library(shinyWidgets)

# Load utility functions
# source("utilities/getTimeFilterChoices.R")
# source("utilities/getMetricsChoices.R")
# source("utilities/getExternalLink.R")


fluidPage(

  
useShinydashboard(),

  # titlePanel("AirBNB USA", windowTitle = FALSE),
  # sidebarPanel(width = 0),
  #   mainPanel(width = 12,
  #     tabsetPanel(type = "tabs",
  #                 tabPanel("Region",
htmlTemplate(
 "www/dashboard.html",
appTitle = 'AirBNB Data',
appVersion = '',
mainLogo = '',
dashboardLogo = '',

Dropdown1 = selectInput(
  "state", "State",
  choices = c('All States', unique(listings_df$state)),
  selected = 'All States',
  selectize = TRUE
),
Dropdown2 = selectInput(
  "city", "City",
  choices = 'All Cities',
  selectize = TRUE
),
Dropdown3 = selectInput(
  "neighborhood", "Neighborhood",
  choices = 'All Neighborhoods',
  selectize = TRUE
),
# <div class="panel panel-chart Summary3">{{ Summary3 }}</div>

miniSummary_tl = infoBoxOutput('listings', width = '100%'),
miniSummary_tr = infoBoxOutput('price', width = '100%'),
miniSummary_bl = infoBoxOutput('hosts', width = '100%'),
miniSummary_br = infoBoxOutput('rating', width = '100%'),
  
Summary1 = plotOutput('neighborhood'),
Summary2 = plotOutput('facet'))
# Summary3 = '',
# marketplace_website = '')

))))

#                     tabPanel("Time", verbatimTextOutput("summary")),
#                     tabPanel("Table", DTOutput('table')))
# 
