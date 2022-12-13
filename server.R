# AirBNB RProject

function(input, output, session) {

  observeEvent(input$state, {
    if(input$state == 'All States') {
      choices = 'All Cities'
    } else {
      df = listings_df %>%
        filter(state == input$state)
      if (length(unique(df$city)) == 1) {
        choices = df$city
      } else {
        choices = c('All Cities', df$city)
      }
    }
    
    updateSelectizeInput(
      session,
      inputId = "city",
      choices = choices
    )
  })
  
  
  observeEvent(input$city, {
    if(input$city == 'All Cities') {
      choices = 'All Neighborhoods'
    } else {
      df = listings_df %>%
        filter(state == input$state)
      choices = df$neighbourhood_cleansed
    }
    updateSelectizeInput(
      session,
      inputId = "neighborhood",
      choices = c('All Neighborhoods', choices)
    )
  })
  
#reactive dfs
  
  listings = reactive({
    if (input$state == 'All States') {
      listings_df
    } else if (input$city == 'All Cities') {
      listings_df %>%
        filter(state == input$state)
    } else if (input$neighborhood == 'All Neighborhoods') {
      listings_df %>%
        filter(city == input$city)
    } else {
      listings_df %>%
        filter(city == input$city,
               neighbourhood_cleansed == input$neighborhood)
      
  }})
  
  hosts = reactive({
    hosts_df %>%
      filter(host_since %in% years_()) 
    })
  
  PRH = reactive({
    PRH_df %>%
      filter(year %in% years_(),
             month %in% months_())
  })
  
  saturation = reactive({
    saturation_df %>%
      filter(year %in% years_(),
             month %in% months_())
  })
  
  neighborhoods = reactive({
    if (input$state == 'All States') {
      neighborhoods_df
    } else if (input$city == 'All Cities') {
      neighborhoods_df %>%
        filter(state == input$state)
    } else {
      neighborhoods_df %>%
        filter(city == input$city)
      
    }})
  
  neighborhoods2 = reactive({

    neighborhoods_df2 %>%
      filter(year %in% years_(),
             month %in% months_()) 

    })
  
  months_ = reactive({
    if (input$month == 'All Months') {
      return(1:12)
    } else {
      return(case_when(input$month == 'January' ~ 1,
                          input$month == 'February' ~ 2,
                          input$month == 'March' ~ 3,
                          input$month == 'April' ~ 4,
                          input$month == 'May' ~ 5,
                          input$month == 'June' ~ 6,
                          input$month == 'July' ~ 7,
                          input$month == 'August' ~ 8,
                          input$month == 'September' ~ 9,
                          input$month == 'October' ~ 10,
                          input$month == 'November' ~ 11,
                          input$month == 'December' ~ 12))
    }
  })
  
  years_ = reactive({
    if (input$to_year == '-') {
      return(input$from_year)
    } else {
      return(input$from_year:input$to_year)
    }
  })
  
 


  
#plots
  
  output$hotel = renderPlot(
    hosts() %>%
      ggplot(aes(host_since, count)) +
      geom_col(aes(fill = airbnb_red), show.legend = FALSE) +
      theme_few() +
      # scale_x_continuous(breaks = c(2008:2022)) +
      # scale_y_continuous(breaks = c(0, 5e3, 10e3, 15e3, 20e3),
      #                    labels = c(0, '5K', '10K', '15K', '20K')) +
      labs(title = 'Competition among AirBNB Hosts',
           x = 'Year',
           y = 'New Hosts'))
  
  output$room = renderPlot(
    saturation() %>%
      ggplot(aes(reorder(state, host_total_listings_count, decreasing = TRUE), 
                 host_total_listings_count)) + 
      geom_boxplot(aes(color = airbnb_red), show.legend = FALSE) +
      theme_few() +
      labs(title = 'Property Saturation',
           x = 'State',
           y = 'Hosts - Total Listings'))
  
  output$neighborhood = renderPlot(
    neighborhoods() %>%
      arrange(desc(count)) %>%
      head(5) %>%
      ggplot(aes(count, reorder(neighbourhood_cleansed, count))) +
      geom_col(aes(fill = airbnb_red), show.legend = FALSE) +
      theme_few() +
      labs(title = 'Top Neighborhoods', 
           x = 'Review Count', 
           y = 'Neighborhood'))
  
  output$facet = renderPlot(
    listings() %>%
      ggplot(aes(price)) +
      geom_density(aes(fill = airbnb_red), show.legend = FALSE) +
      facet_grid(. ~ room_type, scales = 'free') +
      theme_few() +
      labs(title = 'Price Distribution by Property',
           x = 'Price (USD)',
           y = 'Density'))
  
#dataframe tables
  
  output$table = renderDataTable(
    neighborhoods())
  

#info boxes

  output$price <- renderInfoBox({
    price = listings() %>%
      summarise(price = round(mean(price))) %>% 
      as.character()
    infoBox(title = HTML("Average Price<br>"),
            value = HTML("<p style='font-size:45px'>",
                         price,"</p>"),
            color = 'red',
            fill = TRUE,
            icon = icon('dollar-sign')
    )})

  output$listings <- renderInfoBox({
    count = round(dim(listings())[1])
    
    if (count < 1000) {
      count = count
    } else {
      count = paste0(round(count / 1000), 'K')
    }
    
    infoBox(title = HTML("Unique Listings<br>"),
            value = HTML("<p style='font-size:45px'>",
                         count,"</p>"),
            color = 'red',
            fill = TRUE,
            icon = icon('house')
    )})
  
  output$hosts <- renderInfoBox({
    hosts = length(unique(listings()$host_id))
    
    if (hosts < 1000) {
      hosts = hosts
    } else {
      hosts = paste0(round(hosts / 1000), 'K')
    }
    
    infoBox(title = HTML("Distinct Hosts<br>"),
            value = HTML("<p style='font-size:45px'>",
                         hosts,"</p>"),
            color = 'red',
            fill = TRUE,
            icon = icon('person-shelter')
    )})
  
  output$rating <- renderInfoBox({
    rating = listings() %>%
      filter(!review_scores_rating == is.na(review_scores_rating)) %>%
      summarise(round(mean(review_scores_rating), 2)) %>%
      as.character()
    
    infoBox(title = HTML("Average Rating<br>"),
            value = HTML("<p style='font-size:45px'>",
                         rating,"</p>"),
            color = 'red',
            fill = TRUE,
            icon = icon('ranking-star')
    )})
  
  # tab = '&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;'
  output$price_ <- renderInfoBox({
    price_ = PRH() %>%
      summarise(price = round(mean(price))) %>%
      as.character()
    infoBox(title = HTML("Average Price<br>"),
            value = HTML("<p style='font-size:45px'>",
                         price_,"</p>"),
            color = 'red',
            fill = TRUE,
            icon = icon('dollar-sign')
    )})
  
  output$new_hosts <- renderInfoBox({
    hosts = PRH() %>%
      summarise(new_hosts = sum(host_since)) %>%
      as.numeric()
    
    if (hosts > 1e6) {
      hosts = paste0(round(hosts / 1e6, 1), 'M')
    }
    else {
      hosts = paste0(round(hosts / 1e3), 'K')
    }
    
    infoBox(title = HTML("New Hosts<br>"),
            value = HTML("<p style='font-size:45px'>",
                         hosts,"</p>"),
            color = 'red',
            fill = TRUE,
            icon = icon('person-shelter')
    )})
  
  output$reviews <- renderInfoBox({
     reviews = PRH() %>%
      summarise(reviews = sum(reviews)) %>%
      as.numeric()
    
    if (reviews > 1e6) {
      reviews = paste0(round(reviews / 1e6, 1), 'M')
    }
    else if (reviews > 1000) {
      reviews = paste0(round(reviews / 1e3), 'K')
    } else {
      reviews = reviews
    }
    
    infoBox(title = HTML("Number of Reviews<br>"),
            value = HTML("<p style='font-size:45px'>",
                         reviews,"</p>"),
            color = 'red',
            fill = TRUE,
            icon = icon('pen-to-square')
    )})
  
  output$district <- renderInfoBox({
    top_neighborhood = neighborhoods2() %>%
      group_by(year, state, neighbourhood_cleansed) %>%
      
      summarise(count = sum(count)) %>%
      arrange(desc(count)) %>%
      head(1) %>%
      summarise(neighborhood = neighbourhood_cleansed, 
                state = state) %>%
      as.character()
    
    state = top_neighborhood[2]
    neighborhood = top_neighborhood[3]
    
    neighborhood = case_when(grepl('78704|78702', neighborhood) ~  'Austin', 
                             grepl('District 19|District 6', neighborhood) ~ 'Nashville',
                             grepl('Takoma', neighborhood) ~ 'Takoma',
                             grepl('28806|28801', neighborhood) ~ 'Asheville',
                             grepl('Santa Cruz', neighborhood) ~ 'Santa Cruz',
                             grepl('Park Hill', neighborhood) ~ 'Park Hill',
                             TRUE ~ neighborhood)
    
    
    infoBox(title = HTML("Top Neighborhood<br>"),
            value = HTML("<p style='font-size:45px'>",
                         paste0(neighborhood, ', ', state),"</p>"),
            color = 'red',
            fill = TRUE,
            icon = icon('pen-to-square')
    )})

  
  # output$activetab <- renderText(input$exampletabset)
  
selected_state <- reactive({ input$state })
selected_city <- reactive({ input$city })
selected_neighborhood <- reactive({ input$neighborhood })
}