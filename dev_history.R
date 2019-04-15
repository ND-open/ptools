
# --- setup
# For tests
usethis::use_testthat()
usethis::use_test("my-test")

usethis::use_tidy_description()


# --- dev
# Git
usethis::use_git_ignore("dev_history.R")
usethis::use_git_ignore(".Rbuildignore")


# Build
usethis::use_build_ignore("dev_history.R")
usethis::use_build_ignore("README.md")
usethis::use_build_ignore("README.Rmd")


# Pcks
usethis::use_package("httr")
usethis::use_package("magrittr")
usethis::use_package("purrr")
usethis::use_package("tibble")
usethis::use_package("utils")
usethis::use_package("dplyr")




# TEST AFTER PUSH ON GITHUB REPOS
# remove.packages("dftools")

# devtools::install_github("goodfr/dftools")
