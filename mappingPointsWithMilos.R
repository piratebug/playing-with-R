# Libraries
libs <- c("tidyverse", "stringr", "httr", "sf",
          "giscoR", "scales"
)

# Install missing libraries
installed_libs <- libs %in% rownames(installed.packages())
if (any(installed_libs == F)) {
  install.packages(libs[!installed_libs])
}

# Load Libraries
invisible(lapply(libs, library, character.only = T))

# DATA
file_name <- "./data/geonamesPopulation1000.csv"

## Retrieve data from Geonames table on places with population > 1000
get_geonames_data <- function() {
  table_link <- 
    "https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/geonames-all-cities-with-a-population-1000/exports/csv?lang=en&timezone=America%2FLos_Angeles&use_labels=true&delimiter=%3B"
  res <- httr::GET(
    table_link,
    write_disk(file_name),
    progress()
  )
}

get_geonames_data()

## Load data
load_geonames_data <- function() {
  places_df <- read.csv(file_name, sep = ";")
  return(places_df)
}

places_df <- load_geonames_data()

head(places_df)