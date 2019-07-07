
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

## Organize your projects

The first step of one project is to define what you want to do with your
data. If there are several uses to your data you may want to cut your
project in pieces. Straightforward runs will allow you to get quicker
wins and also to keep your teams (end user, devs,… ) motivated.

By default the following structure is created to keep track of your data
processing :

``` r
# Assuming organisation
hdfs
|- landing
|- data
    |- raw
    |- intermediate
    |- final
```

  - `landing` : only outside raw data that will processed then archived.
    If things goes to worst you will be able to start from scratch from
    there.
  - `data` : you operations starts here, the default here is to process
    only csv files before building Impala or Hive tables.
      - `raw` : for primary operations like processing the extension of
        your data (e.g from json to csv).
      - `intermediate` : optionnal, depending on your pipeline you may
        want to reshape the data or add more cleaning steps.
      - `final` : here will be stored the cleaned data that you want to
        build Impala or Hive tables uppon.

There are several operations that you cannot perform easily or not at
all in Impala/Hive (such as complex data transformation, reshaping, …).
But you should perform joins using Hadoop to ensure that all the data is
matched with what is intended no matter how delayed this data was
uploaded and insure that your project is viable in time (e.g 5 years
from now your R code is not optimized to join on that much data).

## Focus on cleaning the data

Thus you can only focus on cleaning your data while not messing with the
`landing folder`. Your final files can be automatically converted to
Impala tables with the corresponding type. Then you may aggregate them
in Hive or Impala.

See the [Get
Sarted](https://nd-open.github.io/ptools/articles/ptools.html) section
for an example of how to use this package.

## What could be usefull as follow up

  - A way to test your data pipeline and not mess with the source data.
  - A way to automatically document and report on the work you have done
    :
      - how the data was gathered
      - data transformation and stats on cleanness / missingness
      - joins performed
  - Tools to audit your pipelines :
      - How to set up daily report on the action performed and their
        quality.
