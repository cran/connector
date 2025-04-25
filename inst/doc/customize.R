## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

# Setting up a tmp folder to use as the working directory for
# the vignette. Also create a folder used in examples below.

tmp <- withr::local_tempdir()
dir.create(path = file.path(tmp, "my_root_path", "my_project"), recursive = TRUE)

library(connector)

## -----------------------------------------------------------------------------
connector_myclass <- R6::R6Class(
  "connector_myclass",
  inherit = Connector
)

connector_myclass$new()

## -----------------------------------------------------------------------------
connector_project <- R6::R6Class(
  "connector_project",
  inherit = ConnectorFS,
  public = list(
    initialize = function(project) {
      private$.project <- project
      path <- file.path(tmp, "my_root_path", project)
      super$initialize(path)
    }
  ),
  private = list(
    .project = NULL
  ),
  active = list(
    project = function() {
      private$.project
    }
  )
)

## -----------------------------------------------------------------------------
my_project <- connector_project$new(project = "my_project")

print(my_project)

## -----------------------------------------------------------------------------
# First list current content:
my_project |>
  list_content_cnt()

# Write some content:
my_project |>
  write_cnt("Hello world!", "my_file.txt")

# List content again:
my_project |>
  list_content_cnt()

# Read the content:
my_project |>
  read_cnt("my_file.txt")

## -----------------------------------------------------------------------------
# Print the generic
print(list_content_cnt)

# List the registered s3 methods
methods("list_content_cnt") |>
  cat(sep = "\n")

## -----------------------------------------------------------------------------
list_content_cnt.connector_project <- function(connector_object, ...) {
  cli::cli_alert("Listing content of {connector_object$project}")
  NextMethod()
}

## -----------------------------------------------------------------------------
# List methods again
methods("list_content_cnt") |>
  cat(sep = "\n")

# Print my_project connector to see associated methods
print(my_project)

## -----------------------------------------------------------------------------
my_project |>
  list_content_cnt()

## -----------------------------------------------------------------------------
my_project_extra <- ConnectorFS$new(
  path = file.path(tmp, "my_root_path", "my_project"),
  extra_class = "my_extra_class"
)

print(my_project_extra)

## -----------------------------------------------------------------------------
list_content_cnt.my_extra_class <- function(connector_object, ...) {
  cli::cli_alert("Listing content of {connector_object$path}")
  NextMethod()
}

## -----------------------------------------------------------------------------
# List methods
methods("list_content_cnt")

# Print my_project_extra connector to see associated methods
print(my_project_extra)

# List content to see the new message
my_project_extra |>
  list_content_cnt()

## -----------------------------------------------------------------------------
read_ext.myformat <- function(path, ...) {
  cli::cli_alert("Reading myformat file")
  readLines(con = path)
}

write_ext.myformat <- function(file, x, ...) {
  cli::cli_alert("Writing myformat file")
  writeLines(text = x, con = file)
}

## -----------------------------------------------------------------------------
# List already existing content:
my_project |>
  list_content_cnt()

# Write some content in myformat:
my_project |>
  write_cnt("Hello new format!", "new_file.myformat")

# List content again:
my_project |>
  list_content_cnt()

# Read the content:
my_project |>
  read_cnt("new_file.myformat")

