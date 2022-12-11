# AirBNB RProject

library(shinydashboard)

dashboardPage(
  dashboardHeader(title = 'AirBNB Data in US'),
  dashboardSidebar(
    sidebarUserPanel('Mr. Hamilton',
                     image = './img/hammi.jpeg'),
    selectizeInput(inputId = 'city',
                   label = 'City',
                   choices = c('All', unique(listings_df$city))),
    selectizeInput(inputId = 'state',
                   label = 'State',
                   choices = unique(listings_df$state)), 
    sidebarMenu(
      menuItem("Plots", tabName = "plots", icon = icon("truck-monster")),
      menuItem("Data", tabName = "data", icon = icon("database"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = 'plots',
              selectizeInput(inputId = 'month',
                             label = 'Month',
                             choices = c('January', 'February', 'March',
                                         'April', 'May', 'June', 'July',
                                         'August', 'September', 'October')), 
              fluidRow(column(5, plotOutput('count')), 
                       column(7, plotOutput('delay')))),
      tabItem(tabName = 'data', DTOutput('table'))
    )
  )
)
