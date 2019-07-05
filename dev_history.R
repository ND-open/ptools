
# --- setup
# For tests
usethis::use_testthat()
usethis::use_test("my-test")

usethis::use_tidy_description()


# --- dev
# Git
usethis::use_git_ignore("dev_history.R")
usethis::use_git_ignore(".Rbuildignore")
usethis::use_git_ignore(".Rhistory")


# Build
usethis::use_build_ignore("dev_history.R")
usethis::use_build_ignore("README.md")
usethis::use_build_ignore("README.Rmd")
usethis::use_build_ignore("data")
usethis::use_build_ignore(".travis.yml")


# Pcks
usethis::use_package("httr")
usethis::use_package("magrittr")
usethis::use_package("purrr")
usethis::use_package("tibble")
usethis::use_package("utils")
usethis::use_package("data.table")
usethis::use_package("DBI")
usethis::use_package("odbc")
usethis::use_package("stringr")

# devtools::build_vignettes(
usethis::use_vignette("ptools")


# TEST AFTER PUSH ON GITHUB REPOS
# remove.packages("ptools")
