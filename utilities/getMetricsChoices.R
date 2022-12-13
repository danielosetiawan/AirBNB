import("dplyr")

consts <- use("constants.R")

createOptionsList <- function(choices, suffix = "") {
  keys <- choices %>%
    lapply("[[", "title") %>%
    unname() %>%
    lapply(function(x) paste(x, suffix))
  
  values <- choices %>%
    lapply("[[", "id")
  
  names(values) <- keys
  return(values)
}

getMetricsChoices <- function(available_metrics, metrics_list, suffix = "") {
  metrics_list[available_metrics] %>% 
    createOptionsList(suffix)
}

getMetricsChoicesByCategory <- function(category, suffix = "") {
  Filter(function(x) x$category == category, consts$metrics_list) %>% 
    createOptionsList(suffix)
}