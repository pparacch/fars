context("make_filename tests")

test_that("make_filename returns expected filename when passing year as integer",{
  expect_match("accident_2017.csv.bz2", make_filename(2017))
})

test_that("make_filename returns expected filename when passing year as character",{
  expect_match("accident_2013.csv.bz2", make_filename("2013"))
})

test_that("make_filename returns a warning when passing an invalid character",{
  invalid_year = "a_string"
  expect_warning(make_filename(invalid_year), "NAs introduced by coercion")
})

