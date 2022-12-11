# Echarts4r map module

import("shiny")
import("echarts4r")
import("htmlwidgets")
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

  # select only those metrics that are available per country
  choices <- getMetricsChoices(consts$map_metrics, consts$metrics_list, suffix = "by country")

  tagList(
    tags$div(
      class = "panel-header",
      selectInput(
        ns("metric"), "Select metric for the map",
        choices,
        width = NULL,
        selectize = TRUE,
        selected = consts$map_metrics[1]
      )
    ),
    echarts4rOutput(ns("countryMap"), height = "100%")
  )
}

init_server <- function(id, df, countries_geo_data, y, m) {
  callModule(server, id, df, countries_geo_data, y, m)
}

server <- function(input, output, session, df, countries_geo_data, y, m) {

    metric <- reactive({ consts$metrics_list[[input$metric]] })

    countries_df <- reactive({
      getCountriesDataByDate(df, y(), m(), metric()$id, sum)
    })

    country_label <- function(visible = FALSE) {
      list(
        show = visible,
        backgroundColor = consts$colors$white,
        borderRadius = 4,
        borderWidth = 0,
        color = consts$colors$secondary,
        padding = c(10, 14),
        formatter = '{b}: {c}',
        shadowBlur = 12,
        shadowColor = "rgba(0,0,0,0.2)",
        shadowOffsetY = 3
      )
    }

    output$countryMap <- renderEcharts4r({
      countries_df() %>% 
        e_charts(country) %>%
        e_map(
          value,
          name = consts$metrics_list[[metric()$id]]$title,
          roam = TRUE,
          scaleLimit = list(min = 1, max = 8),
          itemStyle = list(
            areaColor = consts$colors$ash_light,
            borderColor = consts$colors$white,
            borderWidth = 0.5
          ),
          emphasis = list(
            label = country_label(),
            itemStyle = list(areaColor = consts$colors$primary)
          ),
          select = list(
            label = country_label(visible = TRUE),
            itemStyle = list(areaColor = consts$colors$primary)
          )
        ) %>%
        e_visual_map(
          value,
          inRange = list(color = c(consts$colors$ash_light, consts$colors$secondary))
        ) %>%
        e_tooltip(
          trigger = "item",
          borderWidth = 0,
          extraCssText = "box-shadow: 0 3px 12px rgba(0,0,0,0.2);"
        )
    })
  }