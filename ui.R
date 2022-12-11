# AirBNB RProject

library(shinydashboard)
library(shiny)

# Load utility functions
source("utilities/getTimeFilterChoices.R")
source("utilities/getMetricsChoices.R")
source("utilities/getExternalLink.R")


fluidPage(
  titlePanel("AirBNB USA", windowTitle = FALSE),
  sidebarPanel(width = 0),
    mainPanel(width = 12,
      tabsetPanel(type = "tabs",
                  tabPanel("Region",
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

miniSummary_tl = fluidRow(plotOutput('home')),
miniSummary_tr = fluidRow(plotOutput('room')),
miniSummary_bl = fluidRow(plotOutput('shared')),
miniSummary_br = fluidRow(plotOutput('hotel')),
Summary1 = fluidRow(plotOutput('facet')),
Summary2 = breakdown_chart$ui("breakdown_chart"),
Summary3 = map_chart$ui("map_chart"),
marketplace_website = consts$marketplace_website)),

                    tabPanel("Time", verbatimTextOutput("summary")),
                    tabPanel("Table", DTOutput('table')))
))


# dashboardPage(
#   dashboardHeader(title = 'AirBNB Data: USA'),
#   dashboardSidebar(
#     sidebarUserPanel('Mr. Hamilton',
#                      image = './img/hammi.jpeg'),
#     
#     sidebarMenu(
#       menuItem("Intro", tabName = "plots", icon = icon("truck-monster")),
#       menuItem("EDA", tabName = "data", icon = icon("database")),
#       menuItem("Analysis", tabName = "plots", icon = icon("truck-monster")),
#       menuItem("Data", tabName = "plots", icon = icon("truck-monster")),
#       menuItem("Data", tabName = "data", icon = icon("database")),
#       menuItem("About Me", tabName = "data", icon = icon("database"))
#     )
#   ),
#   dashboardBody(
#     tabItems(
#       tabItem(tabName = 'AirBNB Data',
#               selectizeInput(inputId = 'state',
#                              label = 'State',
#                              choices = c('All', unique(listings_df$state))),
#               selectizeInput(inputId = 'city',
#                              label = 'City',
#                              choices = 'All'),
#               fluidRow(column(7, plotOutput('count')), 
#                        column(5, plotOutput('delay')))),
#       tabItem(tabName = 'data', DTOutput('table'))
#     )
#   )
# )