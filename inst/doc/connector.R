## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
# library(connector)
# library(connector.databricks)
# library(connector.sharepoint)

## ----eval=FALSE---------------------------------------------------------------
# # Load data connections
# db <- connect()

## ----eval=FALSE---------------------------------------------------------------
# # ADaM data
# db$adam
# 
# # TFL data
# db$tfl
# 
# # Metadata
# db$metadata
# 
# # Output on SharePoint
# db$output_sh

## ----eval=FALSE---------------------------------------------------------------
# library(dplyr)
# 
# # Manipulate data
# 
# ## Iris data
# setosa <- iris |>
#   filter(Species == "setosa")
# 
# mean_for_all_iris <- iris |>
#   group_by(Species) |>
#   summarise_all(list(mean, median, sd, min, max))
# 
# ## Mtcars data
# cars <- mtcars |>
#   filter(mpg > 22)
# 
# mean_for_all_mtcars <- mtcars |>
#   group_by(gear) |>
#   summarise(
#     across(
#       everything(),
#       list("mean" = mean, "median" = median, "sd" = sd, "min" = min, "max" = max),
#       .names = "{.col}_{.fn}"
#     )
#   ) |>
#   tidyr::pivot_longer(
#     cols = -gear,
#     names_to = c(".value", "stat"),
#     names_sep = "_"
#   )
# 
# ## Store data
# db$adam |>
#   write_cnt(setosa, "setosa", overwrite = TRUE)
# 
# db$adam |>
#   write_cnt(mean_for_all_iris, "mean_iris", overwrite = TRUE)
# 
# db$adam |>
#   write_cnt(cars, "cars_mpg", overwrite = TRUE)
# 
# db$adam |>
#   write_cnt(mean_for_all_mtcars, "mean_mtcars", overwrite = TRUE)

## ----eval=FALSE---------------------------------------------------------------
# library(gt)
# library(tidyr)
# library(ggplot2)
# 
# # List and load data
# db$adam |>
#   list_content_cnt()
# 
# table <- db$adam |>
#   read_cnt("mean_mtcars")
# 
# gttable <- table |>
#   gt(groupname_col = "gear")
# 
# ## Save table
# db$tfl$write_cnt(gttable$`_data`, "tmeanallmtcars.csv")
# db$tfl$write_cnt(gttable, "tmeanallmtcars.rds")
# 
# ## Using Sharepoint
# tmp_file <- tempfile(fileext = ".docx")
# gtsave(gttable, tmp_file)
# db$output_sh$upload_cnt(tmp_file, "tmeanallmtcars.docx")
# 
# # Manipulate data
# setosa_fsetosa <- db$adam |>
#   read_cnt("setosa") |>
#   filter(Sepal.Length > 5)
# 
# fsetosa <- ggplot(setosa) +
#   aes(x = Sepal.Length, y = Sepal.Width) +
#   geom_point()
# 
# ## Using Databricks Volumes
# ## Store TFLs
# db$tfl$write_cnt(fsetosa$data, "fsetosa.csv")
# db$tfl$write_cnt(fsetosa, "fsetosa.rds")
# 
# ## Using Sharepoint
# tmp_file <- tempfile(fileext = ".png")
# ggsave(tmp_file, fsetosa)
# db$output_sh$upload(tmp_file, "fsetosa.png")
# 
# ## Using Databricks Volumes
# db$tfl$upload_cnt(contents = tmp_file, file_path = "fsetosa.png")

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
' |> writeLines("_connector.yml")

## -----------------------------------------------------------------------------
library(connector)
library(dplyr)
library(ggplot2)

# Let's create ADaM and TFL directories
dir.create("adam")
dir.create("tfl")

# Load data connections
db <- connect()

## Iris data
setosa <- iris |>
  filter(Species == "setosa")

mean_for_all_iris <- iris |>
  group_by(Species) |>
  summarise_all(list(mean, median, sd, min, max))

## Store data
db$adam |>
  write_cnt(setosa, "setosa.rds")

db$adam |>
  write_cnt(mean_for_all_iris, "mean_iris.rds")

## List and load data
db$adam |>
  list_content_cnt()

# Manipulate data
setosa_fsetosa <- db$adam |>
  read_cnt("setosa") |>
  filter(Sepal.Length > 5)

fsetosa <- ggplot(setosa) +
  aes(x = Sepal.Length, y = Sepal.Width) +
  geom_point()

## Store TFLs
db$tfl$write_cnt(fsetosa$data, "fsetosa.csv")
db$tfl$write_cnt(fsetosa, "fsetosa.rds")

## Store images
tmp_file <- tempfile(fileext = ".png")
ggsave(tmp_file, fsetosa)
db$tfl$upload_cnt(tmp_file, "fsetosa.png")

# Check if everything is written into temporary TFL directory
db$tfl$list_content_cnt()

