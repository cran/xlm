#' Transaction object.
#' @description An R6 class representing a transaction on the Stellar network.
#'     It is initialized from the getTransactionDetail() function.
#' @exportClass
#' @field ledger - the sequence number of the ledger from which the transaction was confirmed.
#' @field hash - the cryptographic signature of the transaction (sha256)
#' @field source_account - the account that originates the transaction.
#' @field created_at - when the transaction was submited.
#' @field fee_paid - how much fee was paid (in stroops.)
#' @field response - list containing the raw JSON response.
#' @note https://www.stellar.org/developers/guides/concepts/transactions.html
#' @examples
#' \dontrun{t = Transaction$new("afbe6f687c85d1f34ea18b73629be006518a2a3f5891760086340b4f1e834ccb")}
Transaction <- R6Class("Transaction",
                  public = list(
                    # fields
                    ledger = NA,
                    hash = NA,
                    source_account = NA,
                    created_at = NA,
                    fee_paid = NA,
                    response = NA,
                    # init
                    initialize = function(hash, domain = private$domain_default){
                      response = getTransactionDetail(hash, domain = domain)
                      self$ledger = response[['ledger']]
                      self$hash = response[['hash']]
                      self$source_account = response[['source_account']]
                      self$created_at = response[['created_at']]
                      self$fee_paid = response[['fee_paid']]
                      self$response = response
                    },
                    # methods
                    operations = function(cursor = private$cursor_default,
                                          limit = private$limit_default,
                                          order = private$ord_default,
                                          domain = private$domain_default,
                                          data.table = private$dt_default){
                      return(getOperations_Transaction(self$hash, cursor=cursor, limit=limit,
                                                  order=order, domain=domain, data.table=data.table))
                    },
                    effects = function(cursor = private$cursor_default,
                                       limit = private$limit_default,
                                       order = private$ord_default,
                                       domain = private$domain_default,
                                       data.table = private$dt_default){
                      return(getEffects_Transaction(self$hash, cursor=cursor, limit=limit,
                                               order=order, domain=domain, data.table=data.table))
                    },
                    payments = function(cursor = private$cursor_default,
                                        limit = private$limit_default,
                                        order = private$ord_default,
                                        domain = private$domain_default,
                                        data.table = private$dt_default){
                      return(getPayments_Transaction(self$hash, cursor=cursor, limit=limit,
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
