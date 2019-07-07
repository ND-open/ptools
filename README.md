
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ptools <a href='https://www.next-decision.fr/'><img src='man/figures/ptools_logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.com/ND-open/ptools.svg?branch=master)](https://travis-ci.com/ND-open/ptools)
<!-- badges: end -->

## Overview

`ptools` is a package to help you organize your data pipeline project.
Since setting up a project follows recurrent step, a default procedure
is suggested here to save time. The purpose is also to ease project
upgrades and allow unit testing.

Reporting on the project construction is also important, tools to
achieve this will be developped in the future.

## Installation

This package will be not be deployed to CRAN, you need to install it
from github.

``` r
# To install from github you need the package devtools first
if(!require("devtools", character.only = TRUE)){install.packages("devtools")}

# Then you may intall ptools
devtools::install_github("ND-open/ptools")
```

## Default scheme

Assuming you have imported your data on the HDFS, we suggest you store
those data in `landing/my_project_name`. Then you should create the
folders `data/raw/my_project_name`, `data/intermediate/my_project_name`
and `data/final/my_project_name`.

``` r
# Assuming organisation
hdfs
|- landing
|- data
    |- raw
    |- intermediate
    |- final
```

`ptools` functions provide tools to easily perform operations on the
files while you refine the data from raw to final to finally aggregate
them in Hive or Impala. See the vignette at `vignettes/ptools` for
exemple of use.

## What should comes next to complete this package

  - A way to automatically document and report on the work you have done
    :
      - how the data was gathered
      - data transformation and stats on cleanness / missingness
      - joins performed
  - Tools to audit your pipelines :
      - How to set up daily report on the action performed and their
        quality.
