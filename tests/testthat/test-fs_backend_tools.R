test_that("Create a backend for FS", {
  only_one <- yaml_content_parsed |>
    purrr::pluck("datasources", 1, "backend")

  connection <- create_backend_fs(only_one)

  expect_s3_class(connection, c("ConnectorFS", "R6"))

  ## Extra class
  expect_s3_class(connection, "test2")
})
