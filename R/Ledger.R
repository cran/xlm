#' Ledger object.
#' @description An R6 class representing a Ledger on the Stellar network.
#'     It is initialized from the getLedgerDetail() function.
#' @exportClass
#' @field hash - a cryptographic signature of all of the data inside the ledger.
#' @field sequence - the current sequence number of the ledger
#' @field transaction_count - how many transactions in the ledger.
#' @field closed_at - when the transaction was confirmed.
#' @field total_coins - how many lumens existed on the network at the time the ledger was confirmed.
#' @field response - list containing the raw JSON response.
#' @note https://www.stellar.org/developers/guides/concepts/ledger.html
#' @examples
#' genesis <- Ledger$new("1")
#' genesis$effects()
Ledger <- R6Class("Ledger",
                   public = list(
                     # fields
                     sequence = NA,
                     hash = NA,
                     transaction_count = NA,
                     operation_count = NA,
                     closed_at = NA,
                     total_coins = NA,
                     response = NA,
                     # init
                     initialize = function(sequence, domain = private$domain_default){
                       response = getLedgerDetail(sequence, domain = domain)
                       self$sequence = as.character(response[['sequence']])
                       self$hash = response[['hash']]
                       self$transaction_count = response[['transaction_count']]
                       self$operation_count = response[['operation_count']]
                       self$closed_at = response[['closed_at']]
                       self$total_coins = response[['total_coins']]
                       self$response = response
                     },
                     # methods
                     operations = function(cursor = private$cursor_default,
                                           limit = private$limit_default,
                                           order = private$ord_default,
                                           domain = private$domain_default,
                                           data.table = private$dt_default){
                       return(getOperations_Ledger(self$sequence, cursor=cursor, limit=limit,
                                                    order=order, domain=domain, data.table=data.table))
                     },
                     effects = function(cursor = private$cursor_default,
                                        limit = private$limit_default,
                                        order = private$ord_default,
                                        domain = private$domain_default,
                                        data.table = private$dt_default){
                       return(getEffects_Ledger(self$sequence, cursor=cursor, limit=limit,
                                                 order=order, domain=domain, data.table=data.table))
                     },
                     transactions = function(cursor = private$cursor_default,
                                             limit = private$limit_default,
                                             order = private$ord_default,
                                             domain = private$domain_default,
                                             data.table = private$dt_default){
                       return(getTransactions_Ledger(self$sequence, cursor=cursor, limit=limit,
                                                      order=order, domain=domain, data.table=data.table))
                     },
                     payments = function(cursor = private$cursor_default,
                                         limit = private$limit_default,
                                         order = private$ord_default,
                                         domain = private$domain_default,
                                         data.table = private$dt_default){
                       return(getPayments_Ledger(self$sequence, cursor=cursor, limit=limit,
                                                  order=order, domain=domain, data.table=data.table))
                     })
                   , private = list(
                      limit_default = 200,
                      domain_default = "public",
                      dt_default = TRUE,
                      ord_default = "asc",
                      cursor_default = NULL
                   )
)
