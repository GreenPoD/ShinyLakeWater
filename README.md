# ShinyLakeWater
[Shiny Application Great Lakes Water Quality](https://greenpod.shinyapps.io/GreatLakesWater/)

-----

My Background:

Swimming at my Grandfathers cottage on Lake St. Clair; the water was always murky, strangely warm, a bit smelly and unsettling.

Growing up on the shores of Lake Erie; Certain questions were always in the back of my mind. Whats in the water that I'm swimming in? Should we really be catching and eating the fish?

A chemical engineer at one of the local poluters once told me about the pools of mercury settled at the bottom of the lower lakes. 

Zug island, River Rouge, Maumee River, Toledo, Hamilton, Windsor, Detroit and Sarnia supporting the modern age without any regard for the natural world.

Fast forward to current version of adulthood searching for closure, I decided to clean a large dataset and create a shiny app.

-----

Data Cleaning: 

The data obtained from the [Government of Canada Open Data Portal](https://www.canada.ca/en/services/science/open-data.html) consisted of 5 tables detailing the results of water quality samples from Lake Superior, Lake Huron, Lake Erie, Georgian Bay and Lake Ontario since the year 2000. I'm `missing_data <- c("Lake Michigan", "Lake St.Clair")`. The columns were consistent but some of the descriptions were slightly different.

Cleaning began with `dplyr::bind_rows(c(lake_erie, lake_ontario, lake_huron, georgian_bay, lake_superior))` which stacked all of the tables on top of each other. `janitor::clean_names(great_lakes)` just to clean up the column names. Calling `unique_names <- unique(great_lakes$full_name)` to create a table containing only unique full_names of the contaminants. 

505 unique `full_names` were carefully standardized using a new column `name` as they differed across the tables. Using a hyperlink formula [National Library of Medicine](https://pubchem.ncbi.nlm.nih.gov/) the contaminants were researched and classified as one of following `c("Pesticide", "Incomplete Combustion", "Solvent", "Manufacturing Biproducts", "Flame Retardant", "Research Compounds", "Herbicide", "Banned Pesticide", "Chemical Element", "Heavy Metal", "Plastic Biproduct", "Fungicide", "Colorant" )`. A colour column was also added to distinguish the points on the final map. Cleaning took a few months of research and verification and there may be differing opinions on the classification.

-----

Shiny Application:

The `library(shiny)` package is an efficient way to build and deploy interactive web applications. 

-----

Citation:

Where to begin (gushing), the RStudio IDE is a safe place and the level of care and thought put into every detail humbles me at every turn. Namaste to all of the contributors and the RCommunity!
