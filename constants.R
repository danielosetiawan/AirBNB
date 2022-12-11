# common variables for generating sample data and shiny app (ui & server)
import("dplyr")
import("htmltools")

app_title <- "AirBNB Dataz"
app_version <- "1.0.0"
data_last_day <- "2020-05-10" %>% as.Date()
data_first_day <- "2015-01-01" %>% as.Date()
marketplace_website <- "https://appsilon.com/"

metrics_list <- list(
  revenue = list(
    id = "revenue",
    title = "Sales Revenue",
    currency = "$",
    category= "sales",
    legend = "Revenue"
  ),
  cost = list(
    id = "cost",
    title = "Production Costs",
    currency = "$",
    category= "production",
    legend = "Cost",
    invert_colors = TRUE
  ),
  profit = list(
    id = "profit",
    title = "Profit",
    currency = "$",
    category= "sales",
    legend = "Profit"
  ),
  orders_count = list(
    id = "orders_count",
    title = "Orders",
    currency = NULL,
    category= "sales",
    legend = "Number of orders"
  ),
  produced_items = list(
    id = "produced_items",
    title = "Produced Items",
    currency = NULL,
    category= "production",
    legend = "Produced items"
  ),
  users_active = list(
    id = "users_active",
    title = "Active Users",
    currency = NULL,
    category= "users",
    legend = "Active users"
  ),
  users_dropped_out = list(
    id = "users_dropped_out",
    title = "Dropped Out Users",
    currency = NULL,
    category= "users",
    legend = "Dropped out users",
    invert_colors = TRUE
  ),
  complaints_opened = list(
    id = "complaints_opened",
    title = "Opened Complaints",
    currency = NULL,
    category= "complaints",
    legend = "Opened complaints",
    invert_colors = TRUE
  ),
  complaints_closed = list(
    id = "complaints_closed",
    title = "Closed Complaints",
    currency = NULL,
    category= "complaints",
    legend = "Closed complaints"
  )
)

map_metrics <- c(
  "revenue",
  "orders_count",
  "users_active",
  "users_dropped_out",
  "complaints_opened",
  "complaints_closed"
)

prev_time_range_choices <- list("Previous Year" = "prev_year", "Previous Month" = "prev_month")

appsilonLogo <- HTML("
  <svg class='logo-svg' viewBox='0 0 660.52 262.96'>
    <use href='assets/icons/icons-sprite-map.svg#appsilon-logo'></use>
  </svg>
")

shinyLogo <- HTML("
  <svg class='logo-svg' viewBox='0 0 100 68'>
    <use href='assets/icons/icons-sprite-map.svg#shiny-logo'></use>
  </svg>
")

colors <- list(
  white = "#FFF",
  black = "#0a1e2b",
  primary = "#0099F9",
  secondary = "#15354A",
  ash = "#B3B8BA",
  ash_light = "#e3e7e9"
)