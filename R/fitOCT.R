#' fitOCT
#'
#' @return
#' @export
#'
#' @examples
#' fitOCT()
#'
fitOCT <- function() {
  appDir <- system.file("fitOCT", package = "FitOCTdock")
  shiny::runApp(appDir, display.mode = "normal")
}
