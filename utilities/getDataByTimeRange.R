import("lubridate")
import("dplyr")

getSubsetByTimeRange <- function(df, y, m = NULL, metric) {
  colsToSelect <- c("date", metric)
  if (is.null(m) || m == "0") {
    subset(
      x = df,
      subset = year(date) == y,
      select = colsToSelect
    )
  } else {
    subset(
      x = df,
      subset = year(date) == y & month(date) == m,
      select = colsToSelect
    )
  }
}

getMonthlyDataByYear <- function(df, y, metric) {
  getSubsetByTimeRange(df, y, m = NULL, metric) %>%
    mutate(date = floor_date(date, "month")) %>%
    group_by(date) %>%
    summarize_at(.vars = c(metric), .funs = sumAllNonNAValues)
}

sumAllNonNAValues <- function(v) {
  if (length(v[!is.na(v)]) != 0) {
    sum(v, na.rm = TRUE)
  } else {
    return(NA)
  }
}

getCountriesDataByDate <- function(df, y, m, metric, f = sum) {
  getSubsetByTimeRange(df, y, m, metric = c("country", metric)) %>%
    group_by(country) %>%
    select(metric) %>% 
    rename(value = metric) %>% 
    ungroup()
}