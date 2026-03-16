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

#get_geonames_data()

## Load data
load_geonames_data <- function() {
  places_df <- read.csv(file_name, sep = ";")
  return(places_df)
}

places_df <- load_geonames_data()

#head(places_df)

## Cleaning the data
### creates a new df that passes in only the pieces we need from places_df and renames the columns
places_modified_df <- places_df[, c(2, 7, 14, 20)]
names(places_modified_df) <- c("name", "country_code", "population", "coords")

#head(places_modified_df)

### splits the coords field into two new fields, lat and long
places_modified_df[c("lat", "long")] <-
  stringr::str_split_fixed(
    places_modified_df$coords, ",", 2
  )

### remove the coords field
places_clean_df <- places_modified_df |>
  dplyr::select(-coords)

#head(places_clean_df)