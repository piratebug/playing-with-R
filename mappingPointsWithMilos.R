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

## Converting df to a shapefile / note: crs = coordinate reference system
crsLONGLAT <-
  "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

places_sf <- places_modified_df |>
  sf::st_as_sf(
    coords = c("long", "lat"),
    crs = crsLONGLAT
  )

#places_sf

# Getting Mappy!
ggplot() +
  geom_sf(
    data = places_sf,
    color = "#6FC4D9", fill = "#6FC4D9"
  )

## Filter by country
### https://www.iban.com/country-codes
ggplot() +
  geom_sf(
    data = dplyr::filter(
      places_sf,
      country_code == "GB"
    ),
    color = "#7d1d53", fill = "#7d1d53"
  )

## Calling a country shapefile its by ISo3 code, set it to the same coordinate system
### gisco_get_unit_country also works here (be sure to update parameters)
 uk <- giscoR::gisco_get_countries(
   resolution = "1",
   country = "GBR"
    ) |>
   sf::st_transform(crsLONGLAT)

#plot(uk)

## Check if points exist within the polygon (intersect) and plot only those places
 uk_places <- sf::st_intersection(
   places_sf, uk
 )

#plot(uk_places)
 
## Scale the circle sizes to the population size
 ggplot() +
   geom_sf(
     data = uk_places, 
     aes(size = population),
     color = "#7d1d53",
     alpha = .5
   ) +
   ### Set thresholds for scaling
   scale_size(
     range = c(1, 10),
     breaks = scales::pretty_breaks(n=6)
   )
