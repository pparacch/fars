context("fars_read tests")


test_that("fars_read returns an error when passing non existing filename",{
  non_existing_filename <- "a_non_existing_filename"
  expected_error_message <- paste("file '", non_existing_filename , "' does not exist", sep = "")
  expect_error(fars_read(non_existing_filename), expected_error_message)
})

test_that("fars_read returns an expected data when passing existing filename",{
  existing_filename <- "accident_2013.csv.bz2"
  expected_dim <- c(999L, 50L)
  actual_data <- fars_read(existing_filename)
  expect_false(is.null(actual_data))
  expect_identical(dim(actual_data), expected_dim)
})

test_that("fars_read does not return  output of any type",{
  existing_filename <- "accident_2013.csv.bz2"
  expect_silent(fars_read(existing_filename))
})
