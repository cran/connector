#' Log Read Operation for connector dbi
#'
#' Implementation of the log_read_connector function for the ConnectorDBI class
#'
#' @param connector_object The ConnectorDBI object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @export
log_read_connector.ConnectorDBI <- function(connector_object, name, ...) {
  msg <- paste0(
    name,
    " @ ",
    "driver: ",
    class(connector_object$conn)[1],
    ", dbname: ",
    connector_object$conn@dbname
  )
  whirl::log_read(msg)
}

#' Log Write Operation for connector dbi
#'
#' Implementation of the log_write_connector function for the ConnectorDBI
#' class.
#'
#' @param connector_object The ConnectorDBI object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @export
log_write_connector.ConnectorDBI <- function(connector_object, name, ...) {
  msg <- paste0(
    name,
    " @ ",
    "driver: ",
    class(connector_object$conn)[1],
    ", dbname: ",
    connector_object$conn@dbname
  )
  whirl::log_write(msg)
}

#' Log Remove Operation for connector dbi
#'
#' Implementation of the log_remove_connector function for the
#' ConnectorDBI class.
#'
#' @param connector_object The ConnectorDBI object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @export
log_remove_connector.ConnectorDBI <- function(connector_object, name, ...) {
  msg <- paste0(
    name,
    " @ ",
    "driver: ",
    class(connector_object$conn)[1],
    ", dbname: ",
    connector_object$conn@dbname
  )
  whirl::log_delete(msg)
}
