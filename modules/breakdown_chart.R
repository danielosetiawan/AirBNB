# Ggplot horizontal bar chart module

import("shiny")
import("tidyselect")
import("lubridate")
import("dplyr")
import("utils")
import("tidyr")
import("ggplot2")

export("ui")
export("init_server")

expose("utilities/getMetricsChoices.R")
expose("utilities/getTimeFilterChoices.R")
expose("utilities/getDataByTimeRange.R")
expose("utilities/getPercentChangeSpan.R")

consts <- use("constants.R")

ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "panel-header breakdown-header",
      div(class = "item", "Breakdown"),
    ),
    div(
      class = "chart-breakdown-container",
      plotOutput(ns("breakdown"), width = "100%", height = "200px")
    )
  )
}

init_server <- function(id, df, y, m, previous_time_range) {
  callModule(server, id, df, y, m, previous_time_range)
}

server <- function(input, output, session, df, y, m, previous_time_range) {
  
  output$breakdown <- renderPlot({
    yearly_stats <- read.csv("data/yearly_stats.csv")
    monthly_stats <- read.csv("data/monthly_stats.csv")
    metrics <- names(consts$metrics_list)
    percents <- paste(metrics, ".perc_", previous_time_range(), sep="")

    if (m() == "0") {
      data <- yearly_stats %>%
        filter(year(as.Date(date)) == y())
    } else {
      data <- monthly_stats %>%
        filter(year(as.Date(date)) == y() & month(as.Date(date)) == m())
    }

    data <- data %>%
      select(all_of(percents)) %>%
      gather(all_of(percents), key = "metric", value = "value") %>%
      mutate(
        label = paste(round(value, 1), "%", sep=""),
        barColor = ifelse(value >= 0 | is.na(value), "#0099F9", "#15354A"),
        hOffset = ifelse(value >= 0 | is.na(value), -0.1, 1.1),
      )

    # set metric names as titles
    data["metric"] <- unlist(lapply(consts$metrics_list[metrics], "[", "title"))

    bar <- ggplot(data, aes(metric, value, weight = value))
    bar +
      coord_flip() +
      geom_bar(
        fill = data$barColor,
        show.legend = FALSE,
        width = 0.65,
        stat="identity"
      ) +
      geom_text(
        aes(y = value, label = label),
        vjust = 0.5,
        hjust = data$hOffset,
        color = data$barColor
      ) +
      scale_y_continuous(expand = c(0.15, 0.1)) +
      labs(x = NULL, y = NULL) +
      theme_classic(
        base_size = 14
      ) +
      theme(
        text = element_text(size = 14),
        axis.text.y = element_text(color = "#6E757B"),
        axis.text.x = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank()
      )
  })
}