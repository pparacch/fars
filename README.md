
<!-- README.md is generated from README.Rmd. Please edit that file -->
Overview
========

This repository is connected with the final assignment for **Building R Packages** module of the **[Mastering Software Development in R](https://www.coursera.org/specializations/r)** specialization (coursera). The goal is to apply the basic concepts learnt in the module for creating, writing, documenting, and testing an R package.

The development of the package is done introducing the following software engineering practices:

-   version control using Github/ Git
-   Test Driven Development with unit tests and integration tests
-   Continuous Integration (CI) using [Travis CI](https://travis-ci.org)

What needs to be done
---------------------

-   add the FARS R code provided during the course
-   document the code, creating related help functions with `roxygen2`
-   document the package, using a README file and a vignette to include in your package with `knitr` and **R Markdown**
-   add some unit tests / integration tests using `testthat`
-   add the package on GitHub
-   set up the repository so that the package can be checked and built on Travis with no errors, warnings or notes.

`farsr` package ![Travis Badge](https://travis-ci.org/pparacch/fars.svg?branch=master)
======================================================================================

Overview
--------

The goal of `fars` is to help you performing basic operation on [Fatality Analysis Reporting System](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars) (FARS) data, a nationwide census providing the American public yearly data regarding fatal injuries suffered in motor vehicle traffic crashes. Specifically it allows you to perform the following operations:

-   load the FARS datafile by filename or by years,
-   summarize the number of fatal injuries suffered in motor vehicle traffic crashes by month and year,
-   visualize the fatal injuries suffered in motor vehicle traffic crashes in a specific state (USA) for a specific year.

Installation
------------

``` r
#Using devtools and Github
devtools::install_github("pparacch/fars")
```

Getting Started
---------------

``` r
#load and attach the package
library(farsr)
```

Use the following table to have an overview of the provided functions:

<table style="width:38%;">
<colgroup>
<col width="15%" />
<col width="22%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Function</th>
<th align="left"></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><code>fars_read()</code></td>
<td align="left">Read a FARS datafile</td>
</tr>
<tr class="even">
<td align="left"><code>fars_read_years()</code></td>
<td align="left">Read FARS datafile(s) for provided year(s)</td>
</tr>
<tr class="odd">
<td align="left"><code>fars_summarize_years()</code></td>
<td align="left">Summarizes injuries by month for provided year(s)</td>
</tr>
<tr class="even">
<td align="left"><code>fars_map_state()</code></td>
<td align="left">Visualize map with injuries for provided state (USA) and year</td>
</tr>
</tbody>
</table>

More info can be found in the package vignette `vignette('introduction', package = 'farsr')` and help of provided function e.g. `?farsr::fars_read_years`.
