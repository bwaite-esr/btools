
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pivotCacheExtractor

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/pivotCacheExtractor)](https://CRAN.R-project.org/package=pivotCacheExtractor)
<!-- badges: end -->

Tools to assist with automation.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("bwaite-esr/btools")
```

## Example

You have an excel file with multiple pivot tables and you want the raw
data:

``` r
library(btools)
xlsxPivotCacheExtractor(file = system.file("extdata/test_sheet.xlsx",
package = "btools",mustWork = TRUE))
#> $`1`
#>    id first_name  last_name                   email gender     ip_address
#> 1   1         Hi    Beazley        hbeazley0@wp.com   Male  67.254.76.138
#> 2   2    Wendell  Haresnaip wharesnaip1@4shared.com   Male 158.119.61.151
#> 3   3     Lorens     Widger       lwidger2@yale.edu   Male  236.195.97.62
#> 4   4  Stanleigh Blacksland     sblacksland3@un.org   Male  240.240.57.68
#> 5   5      Gavan      Tousy       gtousy4@house.gov   Male 66.133.246.224
#> 6   6    Perrine     Shreve   pshreve5@freewebs.com Female  25.236.184.34
#> 7   7   Zaccaria     Nibloe       znibloe6@ucsd.edu   Male  250.76.63.189
#> 8   8    Ruttger     Croxon      rcroxon7@prlog.org   Male 232.85.215.192
#> 9   9   Mohandis    Redmain       mredmain8@ftc.gov   Male 171.61.223.221
#> 10 10    Rudiger     Kenney      rkenney9@google.nl   Male  51.111.94.106
#> 
#> $`2`
#>    id                      name                   s_name
#> 1   1              Cattle egret            Bubulcus ibis
#> 2   2            Nile crocodile     Crocodylus niloticus
#> 3   3                   Bushpig     Potamochoerus porcus
#> 4   4         Waterbuck, common            Kobus defassa
#> 5   5           Moccasin, water   Agkistrodon piscivorus
#> 6   6     Parakeet, rose-ringed       Psittacula krameri
#> 7   7           Common ringtail Pseudocheirus peregrinus
#> 8   8            African darter             Anhinga rufa
#> 9   9 Blue-breasted cordon bleu   Uraeginthus angolensis
#> 10 10           Common shelduck          Tadorna tadorna
#>               datetime
#> 1  2020-03-27 01:02:49
#> 2  2020-05-31 12:26:15
#> 3  2020-03-27 12:42:21
#> 4  2020-01-15 18:07:33
#> 5  2019-11-01 22:08:04
#> 6  2020-01-14 00:37:18
#> 7  2019-09-24 00:59:05
#> 8  2020-06-29 12:52:38
#> 9  2019-10-05 15:56:33
#> 10 2020-06-29 06:54:30
```
