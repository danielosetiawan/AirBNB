# AirBNB RProject

library(shiny)
library(shinydashboard)

airbnb_logo = HTML('<img width = "100", 
                   height = "70", 
                   src="./img/airbnb-logo.png" />')
  
dashboardPage(
  dashboardHeader(disable = TRUE,
    # App title visible in browser tab
    title = NULL
  ),
  dashboardSidebar( 
  # tags$style(HTML("
  #     .main-sidebar{
  #       width: 30px;
  #     }")),
    sidebarUserPanel('AirBNB Data',
                     image = './img/airbnb-logo.png'),
    sidebarMenu(
      menuItem("Region", tabName = "time", icon = icon('earth-americas')),
      menuItem("Time", tabName = "region", icon = icon('clock')),
      menuItem("Data", tabName = "data", icon = icon('database'))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = 'region',
        htmlTemplate(
         "www/region.html",
        appTitle = 'AirBNB',
        dashboardLogo = airbnb_logo,
        
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
          
        # Summary1 = plotOutput('neighborhood'),
        Summary1 = '',
        Summary2 = plotOutput('facet'))),
      tabItem(tabName = 'time',
              htmlTemplate(
                "www/region.html",
                appTitle = 'AirBNB',
                dashboardLogo = airbnb_logo,
                
                Dropdown1 = selectInput(
                  'from_year', 'From',
                  choices = 2009:2022,
                  selected = '2008',
                  selectize = TRUE
                ),
                Dropdown2 = selectInput(
                  'to_year', 'To',
                  choices = c('-', 2010:2022),
                  selected = 2022,
                  selectize = TRUE
                ),
                Dropdown3 = selectInput(
                  'month', 'Month',
                  choices = c('All Months', 'January', 'February', 'March',
                              'April', 'May', 'June', 'July', 'August', 
                              'September', 'October', 'November', 'December'),
                  selected = 'All Months',
                  selectize = TRUE
                ),
                
                miniSummary_tl = infoBoxOutput('price_', width = '100%'),
                miniSummary_tr = infoBoxOutput('new_hosts', width = '100%'),
                miniSummary_bl = infoBoxOutput('reviews', width = '100%'),
                miniSummary_br = infoBoxOutput('district', width = '100%'),
                
                Summary1 = plotOutput('hotel'),
                Summary2 = plotOutput('neighborhood'),
                Summary3 = box(
                  title = "Inputs", status = "warning", solidHeader = TRUE,
                  "Box content here", br(), "More box content",
                  sliderInput("slider", "Slider input:", 1, 100, 50),
                  textInput("text", "Text input:")
                )))
                  # plotOutput('room')))
)))

#                     tabPanel("Time", verbatimTextOutput("summary")),
#                     tabPanel("Table", DTOutput('table')))
# ))
