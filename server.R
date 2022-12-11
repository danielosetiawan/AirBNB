# AirBNB RProject

function(input, output) {
  listings = reactive({
    listings_df %>%
      filter(state == input$state & city == input$city)})

    
  output$count = renderPlot(
    listings_df %>%
      ggplot(aes(price)) +
      geom_density(aes(fill = airbnb_red), show.legend = FALSE) +
      scale_x_continuous(breaks = c(0, 250, 500)) +
      facet_grid(. ~ room_type, scales = 'free') +
      theme_few() +
      labs(title = 'Price Distribution by Property', 
           x = 'Price (USD)', 
           y = 'Density'))
  
  output$delay = renderPlot(
    listings_df %>%
      ggplot(aes(price)) +
      geom_density(aes(fill = airbnb_red), show.legend = FALSE) +
      scale_x_continuous(breaks = c(0, 250, 500)) +
      facet_grid(. ~ room_type, scales = 'free') +
      theme_few() +
      labs(title = 'Price Distribution by Property', 
           x = 'Price (USD)', 
           y = 'Density'))
  
  output$table = renderDataTable(
    listings_df %>%
      filter(origin == input$state & dest == input$city))
}
