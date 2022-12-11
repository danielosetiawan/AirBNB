import("glue")

getExternalLink <- function(url, class, ...) {
  tags$a(
    href = url,
    class = glue::glue("logo logo-{class}"),
    target = "_blank",
    rel = "noopener",
    ...
  )
}