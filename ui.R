#myApp2

library(shinydashboard)
uimonth =

dashboardPage(
  dashboardHeader(title = 'NYC '),
  dashboardSidebar(
    sidebarUserPanel('Mr. Hamilton',
                     image = './img/hammi.jpeg'),
    selectizeInput(inputId = 'origin',
                   label = 'Departure airport',
                   choices = unique(flights$origin)),
    selectizeInput(inputId = 'dest',
                   label = 'Arrival airport',
                   choices = unique(flights$dest)), 
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
