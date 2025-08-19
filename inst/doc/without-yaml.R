## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, warning=FALSE-----------------------------------------------------
library(connector)
library(dplyr)

## ----include = FALSE----------------------------------------------------------
# Use a temporary directory for examples
tmp_dir <- withr::local_tempdir()
knitr::opts_knit$set(root.dir = tmp_dir)

## ----include=FALSE------------------------------------------------------------
# Create directories for examples
dir.create("data", showWarnings = FALSE)
dir.create("staging", showWarnings = FALSE)
dir.create("analysis", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)

## -----------------------------------------------------------------------------
# Create a file system connector pointing to the 'data' directory
fs_conn <- connector_fs(path = "data")
fs_conn

## -----------------------------------------------------------------------------
# Create a database connector using SQLite in-memory database
db_conn <- connector_dbi(
  drv = RSQLite::SQLite(),
  dbname = ":memory:"
)
db_conn

## -----------------------------------------------------------------------------
# Write and read data using the file system connector
sample_data <- mtcars[1:5, 1:3]

# Write data - format is determined by file extension
fs_conn |> write_cnt(sample_data, "cars.csv")

# List all available content in this connector
fs_conn |> list_content_cnt()

# Read the data back
retrieved_data <- fs_conn |> read_cnt("cars.csv")
head(retrieved_data)

## -----------------------------------------------------------------------------
# Create a collection of connectors for different data stages
my_connectors <- connectors(
  staging = connector_fs(path = "staging"),
  analysis = connector_fs(path = "analysis")
)

my_connectors

## -----------------------------------------------------------------------------
# Use different connectors for different stages of analysis
iris_sample <- iris[1:10, ]

# Store initial data in the staging area
my_connectors$staging |> write_cnt(iris_sample, "iris_raw.rds")

# Process the data
processed <- iris_sample |>
  group_by(Species) |>
  summarise(mean_length = mean(Sepal.Length))

# Store the analysis results
my_connectors$analysis |> write_cnt(processed, "iris_summary.csv")

# Check contents of each connector
my_connectors$staging |> list_content_cnt()
my_connectors$analysis |> list_content_cnt()

## -----------------------------------------------------------------------------
# Mix file system and database connectors in one collection
mixed_connectors <- connectors(
  files = connector_fs(path = "output"),
  database = connector_dbi(RSQLite::SQLite(), dbname = ":memory:")
)

# Store the same data in different formats
test_data <- data.frame(x = 1:3, y = letters[1:3])

# Save as CSV file
mixed_connectors$files |> write_cnt(test_data, "test.csv")

# Save as database table
mixed_connectors$database |> write_cnt(test_data, "test_table")

# List contents from both storage types using the same function
mixed_connectors$files |> list_content_cnt()
mixed_connectors$database |> list_content_cnt()

