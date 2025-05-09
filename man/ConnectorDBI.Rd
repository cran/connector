% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dbi.R
\name{ConnectorDBI}
\alias{ConnectorDBI}
\title{Connector for DBI databases}
\description{
Connector object for DBI connections. This object is used to interact with DBI compliant database backends.
See the \href{https://dbi.r-dbi.org/}{DBI package} for which backends are supported.
}
\details{
We recommend using the wrapper function \code{\link[=connector_dbi]{connector_dbi()}} to simplify the process of
creating an object of \link{ConnectorDBI} class. It provides a more intuitive and user-friendly
approach to initialize the ConnectorFS class and its associated functionalities.

Upon garbage collection, the connection will try to disconnect from the database.
But it is good practice to call \link{disconnect_cnt} when you are done with the connection.
}
\examples{
# Create DBI connector
cnt <- ConnectorDBI$new(RSQLite::SQLite(), ":memory:")
cnt

# You can do the same thing using wrapper function connector_dbi()
cnt <- connector_dbi(RSQLite::SQLite(), ":memory:")
cnt
# Write to the database
cnt$write_cnt(iris, "iris")

# Read from the database
cnt$read_cnt("iris") |>
  head()

# List available tables
cnt$list_content_cnt()

# Use the connector to run a query
cnt$conn

cnt$conn |>
  DBI::dbGetQuery("SELECT * FROM iris limit 5")

# Use dplyr verbs and collect data
cnt$tbl_cnt("iris") |>
  dplyr::filter(Sepal.Length > 7) |>
  dplyr::collect()

# Disconnect from the database
cnt$disconnect_cnt()

}
\section{Super class}{
\code{\link[connector:Connector]{connector::Connector}} -> \code{ConnectorDBI}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{conn}}{The DBI connection. Inherits from \link[DBI:DBIConnector-class]{DBI::DBIConnector}}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-ConnectorDBI-new}{\code{ConnectorDBI$new()}}
\item \href{#method-ConnectorDBI-disconnect_cnt}{\code{ConnectorDBI$disconnect_cnt()}}
\item \href{#method-ConnectorDBI-tbl_cnt}{\code{ConnectorDBI$tbl_cnt()}}
\item \href{#method-ConnectorDBI-clone}{\code{ConnectorDBI$clone()}}
}
}
\if{html}{\out{
<details open><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="connector" data-topic="Connector" data-id="list_content_cnt"><a href='../../connector/html/Connector.html#method-Connector-list_content_cnt'><code>connector::Connector$list_content_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="Connector" data-id="print"><a href='../../connector/html/Connector.html#method-Connector-print'><code>connector::Connector$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="Connector" data-id="read_cnt"><a href='../../connector/html/Connector.html#method-Connector-read_cnt'><code>connector::Connector$read_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="Connector" data-id="remove_cnt"><a href='../../connector/html/Connector.html#method-Connector-remove_cnt'><code>connector::Connector$remove_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="Connector" data-id="write_cnt"><a href='../../connector/html/Connector.html#method-Connector-write_cnt'><code>connector::Connector$write_cnt()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ConnectorDBI-new"></a>}}
\if{latex}{\out{\hypertarget{method-ConnectorDBI-new}{}}}
\subsection{Method \code{new()}}{
Initialize the connection
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ConnectorDBI$new(drv, ..., extra_class = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{drv}}{Driver object inheriting from \link[DBI:DBIDriver-class]{DBI::DBIDriver}.}

\item{\code{...}}{Additional arguments passed to \code{\link[DBI:dbConnect]{DBI::dbConnect()}}.}

\item{\code{extra_class}}{\link{character} Extra class to assign to the new connector.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ConnectorDBI-disconnect_cnt"></a>}}
\if{latex}{\out{\hypertarget{method-ConnectorDBI-disconnect_cnt}{}}}
\subsection{Method \code{disconnect_cnt()}}{
Disconnect from the database.
See also \link{disconnect_cnt}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ConnectorDBI$disconnect_cnt()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\link{invisible} \code{self}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ConnectorDBI-tbl_cnt"></a>}}
\if{latex}{\out{\hypertarget{method-ConnectorDBI-tbl_cnt}{}}}
\subsection{Method \code{tbl_cnt()}}{
Use dplyr verbs to interact with the remote database table.
See also \link{tbl_cnt}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ConnectorDBI$tbl_cnt(name, ...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{name}}{\link{character} Name of the content to read, write, or remove. Typically the table name.}

\item{\code{...}}{Additional arguments passed to the method for the individual connector.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A \link[dplyr:tbl]{dplyr::tbl} object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ConnectorDBI-clone"></a>}}
\if{latex}{\out{\hypertarget{method-ConnectorDBI-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ConnectorDBI$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
