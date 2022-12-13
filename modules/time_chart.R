# Dygraphs vertical bar chart module

import("shiny")
import("dygraphs")
import("glue")
import("tidyselect")
import("lubridate")
import("xts")
import("dplyr")

export("ui")
export("init_server")

expose("utilities/getMetricsChoices.R")
expose("utilities/getTimeFilterChoices.R")
expose("utilities/getDataByTimeRange.R")
expose("utilities/getPercentChangeSpan.R")

consts <- use("constants.R")

ui <- function(id) {
  ns <- NS(id)

  # Add all available metrics to dygraph chart
  choices <- getMetricsChoices(names(consts$metrics_list), consts$metrics_list)

  tagList(
    tags$div(
      class = "panel-header",
      selectInput(
        ns("metric"), "Select metric for the time chart",
        choices,
        width = NULL,
        selectize = TRUE,
        selected = choices[[1]]
      )
    ),
    tags$div(
      class = "chart-time-container",
      dygraphOutput(ns("dygraph"), height = "240px")
    )
  )
}

init_server <- function(id, df, y, m, previous_time_range) {
  callModule(server, id, df, y, m, previous_time_range)
}

server <- function(input, output, session, df, y, m, previous_time_range) {

  metric <- reactive({ consts$metrics_list[[input$metric]] })

  dy_bar_chart <- function(dygraph) {
    dyPlotter(
      dygraph = dygraph,
      name = "BarChart",
      path = system.file("plotters/barchart.js", package = "dygraphs")
    )
  }

  output$dygraph <- renderDygraph({
    metric_change_key <- paste0(metric()$id, ".change_", previous_time_range())
    metric_suffix <- ifelse(!is.null(metric()$currency), glue::glue(" ({metric()$currency})"), "")
    metric_legend <- paste0(metric()$legend, metric_suffix)

    if (m() == "0") {
      subset <- getMonthlyDataByYear(df, y(), metric = c(metric()$id, all_of(metric_change_key)))
      diff_label <- "prev year diff"
    } else {
      subset <- getSubsetByTimeRange(df, y(), m(), metric = c(metric()$id, all_of(metric_change_key)))
      diff_label <- ifelse(previous_time_range() == "prev_year",
                           "change to prev. year",
                           "change to prev. month")
    }

    data <- xts(x = select(subset, c(metric()$id, all_of(metric_change_key))), order.by = subset$date)

    dygraph(data) %>%
      dy_bar_chart() %>%
      dyAxis("y", axisLabelWidth = 60) %>%
      dyAxis("x", drawGrid = FALSE) %>%
      dySeries(metric()$id, label = metric_legend, color = "#0099F9") %>%
      dySeries(all_of(metric_change_key), label = diff_label, color = "#15354A") %>%
      dyOptions(
        includeZero = FALSE,
        axisLineColor = "#585858",
        gridLineColor = "#bdc2c6",
        axisLabelFontSize = 12,
        axisLabelColor = "#585858",
        disableZoom = TRUE
      )
  })
}