% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getTransactions.R
\name{getTransactions}
\alias{getTransactions}
\title{Returns all valid transactions.}
\usage{
getTransactions(limit, cursor = NULL, order = "asc",
  data.table = TRUE, domain = "public")
}
\arguments{
\item{limit}{numeric - the number of records to return. Default is 10.}

\item{cursor}{numeric - optional, a paging token - where to start from. Can also be "now".}

\item{order}{character - optional, "asc" or "desc"}

\item{data.table}{boolean - if TRUE, a data.table is returned. If FALSE or NULL, a list is returned.}

\item{domain}{character - signalling to query the testnet or public network. Can be either "testnet" or "public". boolean - if TRUE, a data.table is overwritten and the server-side streaming capability is utilised. A list will be returned.}
}
\value{
data.table (by default) or list
}
\description{
Return all valid transactions in pages or stream them to R.
}
\note{
https://www.stellar.org/developers/horizon/reference/endpoints/transactions-all.html
}
\examples{
getTransactions(10, domain = "testnet")
}
