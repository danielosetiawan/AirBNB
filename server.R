#myApp2

function(input, output) {
  flights_delay = reactive({
    flights %>%
      filter(origin == input$origin & dest == input$dest) %>%
      mutate(month = case_when(month == 1 ~ 'January',
                               month == 2 ~ 'February',
                               month == 3 ~ 'March',
                               month == 4 ~ 'April',
                               month == 5 ~ 'May',
                               month == 6 ~ 'June',
                               month == 7 ~ 'July',
                               month == 8 ~ 'August',
                               month == 9 ~ 'September',
                               month == 10 ~ 'October',
                               month == 11 ~ 'November',
                               month == 12 ~ 'December')) %>%
      group_by(month, carrier) %>%
      summarise(count = n(),
                departure = mean(dep_delay),
                arrival = mean(arr_delay))})
    
  output$count = renderPlot(
    flights_delay() %>%
      filter(month == input$month) %>%
      ggplot(aes(x = carrier, y = count)) + 
      geom_col(fill = 'lightblue') + 
      labs(title = 'Number of Flights'))
  
  output$delay = renderPlot(
    flights_delay() %>%
      filter(month == input$month) %>%
      pivot_longer(c(departure:arrival),
                   names_to = 'type', values_to = 'delay') %>%
      ggplot(aes(x = carrier, y = delay)) +
      geom_col(aes(fill = type), position = 'dodge') +
      labs(title = 'Average Delay'))
  
  output$table = renderDataTable(
    flights %>%
      filter(origin == input$origin & dest == input$dest))
}
