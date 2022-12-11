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
      labs(x = 'Price (USD)',
           y = 'Density'))
  
  output$shared = renderPlot(
    listings() %>%
      filter(room_type == 'Shared room') %>%
      ggplot(aes(price)) +
      geom_density(aes(fill = airbnb_red), show.legend = FALSE) +
      theme_few() +
      labs(x = 'Price (USD)',
           y = 'Density'))
  
  output$facet = renderPlot(
    listings() %>%
      ggplot(aes(price)) +
      geom_density(aes(fill = airbnb_red), show.legend = FALSE) +
      facet_grid(. ~ room_type, scales = 'free') +
      theme_few() +
      labs(x = 'Price (USD)',
           y = 'Density'))
  
  output$table = renderDataTable(
    listings())
}
