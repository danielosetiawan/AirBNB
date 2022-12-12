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
  
  
  output$home = renderPlot(
    listings() %>%
      filter(room_type == 'Entire home/apt') %>%
      ggplot(aes(price)) +
      geom_density(aes(fill = airbnb_red), show.legend = FALSE) +
      theme_few() +
      labs(x = 'Price (USD)',
           y = 'Density'))
  
  output$hotel = renderPlot(
    listings() %>%
      filter(room_type == 'Hotel room') %>%
      ggplot(aes(price)) +
      geom_density(aes(fill = airbnb_red), show.legend = FALSE) +
      theme_few() +
      labs(x = 'Price (USD)',
           y = 'Density'))
  
  output$room = renderPlot(
    listings() %>%
      filter(room_type == 'Private room') %>%
      ggplot(aes(price)) +
      geom_density(aes(fill = airbnb_red), show.legend = FALSE) +
      theme_few() +
      labs(title = 'Price Distribution by Property',
           x = 'Price (USD)',
           y = 'Density'))
  
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
  
#dataframe
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
  
  output$activetab <- renderText(input$exampletabset)
  
selected_state <- reactive({ input$state })
selected_city <- reactive({ input$city })
selected_neighborhood <- reactive({ input$neighborhood })
}