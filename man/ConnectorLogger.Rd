% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cnt_logger_generics.R
\docType{data}
\name{ConnectorLogger}
\alias{ConnectorLogger}
\title{Create a New Connector Logger}
\format{
An object of class \code{ConnectorLogger} of length 0.
}
\usage{
ConnectorLogger
}
\value{
An S3 object of class "ConnectorLogger" containing:
\itemize{
\item An empty list
\item Class attribute set to "ConnectorLogger"
}
}
\description{
Creates a new empty connector logger object of class
"ConnectorLogger".
This is an S3 class constructor that initializes a logging structure for
connector operations.
}
\details{
Create a New Connector Logger
}
\examples{
logger <- ConnectorLogger
class(logger) # Returns "ConnectorLogger"
str(logger) # Shows empty list with class attribute

}
\keyword{datasets}
