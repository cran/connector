## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----include = FALSE----------------------------------------------------------
# Use a temporary directory as working directory for the example below
tmp <- withr::local_tempdir()
knitr::opts_knit$set(root.dir = tmp)

## ----include = FALSE----------------------------------------------------------
'metadata:
  adam_path: !expr file.path(getwd(), "adam")
  tfl_path: !expr file.path(getwd(), "tfl")

datasources:
  - name: "adam"
    backend:
      type: "connector::connector_fs"
      path: "{metadata.adam_path}"
  - name: "tfl"
    backend:
      type: "connector::connector_fs"
      path: "{metadata.tfl_path}"
' |>
  writeLines("_connector.yml")

## ----include = FALSE----------------------------------------------------------
library(connector)
library(dplyr)
library(ggplot2)

# Let's create ADaM and TFL directories
dir.create("adam")
dir.create("tfl")

## -----------------------------------------------------------------------------
# Load data connections
db <- connect()

## -----------------------------------------------------------------------------
## Iris data
setosa <- iris |>
  filter(Species == "setosa")
## Store data
db$adam |>
  write_cnt(setosa, "setosa.rds")

## -----------------------------------------------------------------------------
mean_for_all_iris <- iris |>
  group_by(Species) |>
  summarise_all(list(mean, median, sd, min, max))

db$adam |>
  write_cnt(mean_for_all_iris, "mean_iris.rds")

## List and load data
db$adam |>
  list_content_cnt()

## -----------------------------------------------------------------------------
# Read and filter data
setosa_filtered <- db$adam |>
  read_cnt("setosa") |>
  filter(Sepal.Length > 5)

## -----------------------------------------------------------------------------
# Create a plot
plot_setosa <- ggplot(setosa_filtered) +
  aes(x = Sepal.Length, y = Sepal.Width) +
  geom_point()

## Store data and plot objects
db$tfl |>
  write_cnt(plot_setosa$data, "setosa_data.csv")
db$tfl |>
  write_cnt(plot_setosa, "setosa_plot.rds")

## Store plot image
tmp_file <- tempfile(fileext = ".png")
ggsave(tmp_file, plot_setosa)
db$tfl |>
  upload_cnt(tmp_file, "setosa_plot.png")

# List all files in the TFL directory
db$tfl |>
  list_content_cnt()

