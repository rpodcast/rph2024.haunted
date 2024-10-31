
# R/Pharma 2024 Haunted Places Quiz!

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

![](https://shinydevseries-assets.us-east-1.linodeobjects.com/app_screenshot.png)

This repository contains a spooky Shiny application testing your math skills with randomly-generated quiz questions in the context of documented Haunted places in the United States! The data set used in this application is the [**Haunted Places in the United States**](https://github.com/rfordatascience/tidytuesday/tree/438293a970874a9b73c42bf58518f7dfe059fb29/data/2023/2023-10-10), shared by the fine folks in the [Tidy Tuesday](https://github.com/rfordatascience/tidytuesday) social data project and compiled by [Tim Renner](https://github.com/timothyrenner/shadowlands-haunted-places), with the original source coming from the [Shadowlands Haunted Places Index](https://www.theshadowlands.net/places/).

You can visit the application (generously hosted on Posit Connect Cloud) at [https://bit.ly/rph2024haunted](https://bit.ly/rph2024haunted)

## Application Workflow & Technical Stack

* This application was built using the [R language](https://r-project.org) with the [Shiny](https://shiny.posit.co/) package for creating web applications with R. Speaking of packages, the application itself is built as an R package using the [`{golem}`](https://thinkr-open.github.io/golem/) framework for robust applications. You may have heard my praise for `{golem}` on [episode 25](https://www.youtube.com/watch?v=agwgiLpiBFo&t=680s) of the [Shiny Developer Series](https://shinydevseries.com/interview/ep025/)

> Once you go golem, you never go back!

* The haunted places data set (stored in CSV format) is imported smoothly with the [`{duckplyr}`](https://duckplyr.tidyverse.org/) R package, which is a powerful R binding to the [DuckDB](https://duckdb.org/) database format.
* Visualization of the interactive map depicting the haunted place locations is powered by [`{leaflet}`](https://rstudio.github.io/leaflet/index.html). As a complete novice to spatial visualizations, it was very straight-forward to launch an interactive map with click events in Shiny, and even customize the icons for each marker to fit the Halloween theme!
* The quiz questions are "procedurally-generated" on the fly using the newly-created [`{elmer}`](https://github.com/tidyverse/elmer) R package, which is using the GPT4o-mini model. Upon app initialization, a custom prompt is sent to the AI bot to frame the context of the haunted places. Once the user selects a location, a dynamically-generated prompt based on the haunted place description and location is sent to bot and returns the mathematical question using the context of the haunted place as inspiration.
* Custom theming of the application is powered by [`{bslib}`](https://rstudio.github.io/bslib/), which gives me a straight-forward way of customizing web page colors and incorporate small CSS customizations as well as custom Google fonts.

## Installation

You can install the development version of rph2024.haunted from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("rpodcast/rph2024.haunted")
```

## Credits & Attribution

* Icons for the map markers available from [flaticon](https://www.flaticon.com/free-icons/halloween)

## Code of Conduct

Please note that the rph2024.haunted project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

