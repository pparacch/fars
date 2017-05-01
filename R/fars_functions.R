#' FARS Data Input.
#'
#' Reads a FARS data file in R as data frame table.
#'
#' This function is the principal means of reading FARS tabular data into R.
#'
#' The file must be in a CSV format. If the file, specified through \code{filename},
#' does not exist the execution is stopped and an error is returned. Otherwise the
#' content of the file is read. Please note that \strong{while reading the file all
#' warnings are suppressed}.
#'
#' @param file The name of the file which the data are to be read from.
#'
#' @return  A data frame table (see \code{\link[dplyr]{tbl_df}} in the \code{dplyr} package).
#'
#' @section Depends on:
#' \enumerate{
#'   \item \code{\link[readr]{read_csv}} in the \code{readr} package.
#'   \item \code{\link[dplyr]{tbl_df}} in the \code{dplyr} package.
#' }
#'
#' @examples
#' \dontrun{
#' fars_read("/tmp/data/fars/accident_2013.csv.bz2")
#' }
#'
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}

#' FARS create a file name.
#'
#' Create a file name, using the provided \code{year}, following the FARS pattern
#' \code{"accident_<year>.csv.bz2"}.
#'
#' @param year The year of interest as \code{integer} or \code{character}.
#'
#' @return  A \code{character} representing the file name.
#'
#' @examples
#' make_filename(1976)
#' make_filename("2017")
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}

#' FARS Read years.
#'
#' Reads the FARS data file(s) for the provided years in R as data frame table(s) and,
#' for each one of them, keeps only the \code{MONTH} and \code{year} variables.
#'
#' For each provided year the following steps are executed:
#' \enumerate{
#'   \item Build the FARS file name from \code{year} (using \code{\link{make_filename}}).
#'   \item Read the FARS data file in R as a data frame table (using \code{\link{fars_read}}).
#'   \item Add a \code{year} variable to the data frame table.
#'   \item Keep \code{MONTH} and \code{year} variables only from the data frame table.
#' }
#'
#'The data file names must be compliant with FARS pattern name. The data files must be located
#'in the working directory. If a file does not exist in the working directory the associated data
#'is set to \code{NULL}.
#'
#' @param years A vector containing the years of interests as \code{integer} or
#' \code{character}.
#'
#' @return  A list containing the selected data as a data frame
#' table (see \code{\link[dplyr]{tbl_df}} in the \code{dplyr} package) for each provided year.
#'
#' @section Depends on:
#' \enumerate{
#'   \item \code{\link[dplyr]{mutate}} and \code{\link[dplyr]{select}} in the \code{dplyr} package.
#' }
#'
#' @importFrom magrittr "%>%"
#'
#' @examples
#' \dontrun{
#' fars_read_years(c(2013, 2014, 2015))
#' fars_read_years(c("2013", "2014", "2015"))
#' }
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>% dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#' FARS summarize years.
#'
#' Summarizes the number of fatal injuries suffered in motor vehicle traffic
#' crashes by month for each provided year.
#'
#' This function performs the steps below:
#' \enumerate{
#'   \item Read the FARS data files in R as a data frame tables for
#'   provided years (using \code{\link{fars_read_years}}).
#'   \item Bind all of the data frame tables by row into one data frame table (see \code{\link[dplyr]{bind_cols}}).
#'   \item Summarize the number of incidents by \code{year} and \code{MONTH}.
#' }
#'
#' @param years A vector containing the years of interests as \code{integer} or
#' \code{character}.
#'
#' @return A data frame table (see \code{\link[dplyr]{tbl_df}} in the \code{dplyr} package).
#'
#' @section Depends on:
#' \enumerate{
#'   \item \code{\link[dplyr]{bind_rows}}, \code{\link[dplyr]{group_by}} and \code{\link[dplyr]{summarize}} in the
#'   \code{dplyr} package.
#'   \item \code{\link[tidyr]{spread}} in the \code{tidyr} package.
#' }
#'
#' @importFrom magrittr "%>%"
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(c(2013, 2014))
#' fars_summarize_years(c("2013", "2014"))
#' }
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}

#' FARS map states.
#'
#' Plots on a USA State map the fatal injuries suffered in motor vehicle traffic crashes for
#' the requested year and state.
#'
#' This function performs the steps below:
#' \enumerate{
#'   \item Build the FARS file name from \code{year} (using \code{\link{make_filename}}).
#'   \item Read the FARS data file in R as a data frame tables (using \code{\link{fars_read}}).
#'   \item Plot on a USA State map all the incidents related to the selected State (\code{state}).
#' }
#'
#' If the provided \code{state} is not valid then execution is stopped and an
#' error is returned.
#'
#' If the provided \code{state} is valid and does not have any incidents then
#' execution is stopped and a message is returned.
#'
#' @param years A vector containing the years of interests as \code{integer} or
#' \code{character}.
#' @param state.num The State identifier as an \code{integer} or a \code{character} .
#'
#' @section Depends on:
#' \enumerate{
#'   \item \code{\link[dplyr]{filter}} in the \code{dplyr} package.
#'   \item \code{\link[maps]{map}} in the \code{map} package.
#'   \item \code{\link[graphics]{points}} in the \code{graphics} package.
#' }
#'
#' @examples
#' \dontrun{
#' fars_map_state(4, 2013)
#' fars_map_state("4", "2013")
#' }
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
