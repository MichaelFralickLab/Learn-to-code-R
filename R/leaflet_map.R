#' ---
#' title: "Where you at?"
#' author: "Learn to Code R"
#' date: "2022-05-29"
#' output:
#'   html_document:
#'
#' ---
#'
#' Let's make a map of where we are all joining from:
#'
#' 1. Google maps > your area (not precise location) > click drop a pin >
#' copy the coordinates from the card at the bottom of the map.
#'
#' 2. Fill in your coordinates here:
#' https://forms.gle/1XoxfkhGLxqEHik9A
#'
#' render this file to html with
#' rmarkdown::render('R/leaflet_map.R')

library(tidyverse)
library(leaflet)
library(googlesheets4)


# coords <-
#   googlesheets4::read_sheet(
#     "https://docs.google.com/spreadsheets/d/1EpByX-P6ou74xqcTF4gX388g-zbMEHPyHsBZADyMhsU/edit?usp=sharing") |>
#   mutate(popup = str_glue('Responded <b>{Timestamp}</b><br>
#                           Lat ~ <b>{round(latitude, 2)}</b><br>
#                           Lng ~ <b>{round(longitude, 2)}</b>
#                           ')) |>
#   glimpse()


# leaflet::leaflet(data = coords) |>
#   leaflet::addTiles() |>
#   leaflet::addMarkers()

# coords |>
#   leaflet::leaflet() |>
#   leaflet::addTiles() |>
#   leaflet::addProviderTiles(providers$CartoDB.Positron) |>
#   leaflet::addMarkers(popup = ~popup, label = ~Timestamp)

