#' Account object.
#' @description An R6 class representing an Account on the Stellar network.
#'     It is initialized from the getAccountDetail() function.
#' @exportClass
#' @field pk - character representing the public key of the account.
#' @field sequence - the current transaction sequence number of the account.
#' @field balances - a list of balances, including the native XLM and any other assets the account holds.
#' @field signers - get information about the signers who authorize activity on the account.
#' @field data - get any data key-value pairs (not secret keys) that have been assigned to the account.
#' @field response - list containing the raw JSON response.
#' @note https://www.stellar.org/developers/guides/concepts/accounts.html
#' @examples
#' binance <- Account$new("GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC")
#' binance$effects()
Account <- R6Class("Account",
                   public = list(
                     # fields
                     account_id = NA,
                     sequence = NA,
                     balances = NA,
                     signers = NA,
                     data = NA,
                     response = NA,
                     last_refreshed = NA,
                     domain = NA,
                     # init
                     initialize = function(pk, domain = private$domain_default){
                       response = getAccountDetail(pk, domain = domain)
                       self$account_id = response[['account_id']]
                       self$sequence = response[['sequence']]
                       self$balances = response[['balances']]
                       self$signers = response[['signers']]
                       self$data = response[['data']]
                       self$domain = domain
                       self$response = response
                       self$last_refreshed = Sys.time()
                     },
                     # methods
                     operations = function(cursor = private$cursor_default,
                                           limit = private$limit_default,
                                           order = private$ord_default,
                                           domain = private$domain_default,
                                           data.table = private$dt_default){
                       return(getOperations_Account(self$account_id, cursor=cursor, limit=limit,
                                                    order=order, domain=domain, data.table=data.table))
                     },
                     offers = function(cursor = private$cursor_default,
                                       limit = private$limit_default,
                                       order = private$ord_default,
                                       domain = private$domain_default,
                                       data.table = private$dt_default){
                       return(getOffers_Account(self$account_id, cursor=cursor, limit=limit,
                                                    order=order, domain=domain, data.table=data.table))
                     },
                     effects = function(cursor = private$cursor_default,
                                        limit = private$limit_default,
                                        order = private$ord_default,
                                        domain = private$domain_default,
                                        data.table = private$dt_default){
                       return(getEffects_Account(self$account_id, cursor=cursor, limit=limit,
                                                    order=order, domain=domain, data.table=data.table))
                     },
                     transactions = function(cursor = private$cursor_default,
                                             limit = private$limit_default,
                                             order = private$ord_default,
                                             domain = private$domain_default,
                                             data.table = private$dt_default){
                       return(getTransactions_Account(self$account_id, cursor=cursor, limit=limit,
                                                    order=order, domain=domain, data.table=data.table))
                     },
                     payments = function(cursor = private$cursor_default,
                                         limit = private$limit_default,
                                         order = private$ord_default,
                                         domain = private$domain_default,
                                         data.table = private$dt_default){
                       return(getPayments_Account(self$account_id, cursor=cursor, limit=limit,
                                                    order=order, domain=domain, data.table=data.table))
                     },
                     get_minimum_balance = function(){
                       if(!exists('subentry_count', self$response)) return(0)
                       return(private$min_amount + self$response[['subentry_count']] * private$amount_per_trustline)
                     },
                     get_xlm_balance = function(){
                        if(length(self$balances) == 0) stop("Balances appear to have not been initialised, for missing for an unknown reason.")
                        for(b in self$balances){
                          asset_type = grep("asset_type", names(b))
                          balance = grep("balance", names(b))
                          if(b[asset_type] == "native") return(as.numeric(b[balance]))
                          next
                        }
                       stop("Native balance not found for some unknown reason.")
                     },
                     usd_value = function(){
                       return(price() * self$get_xlm_balance())
                     },
                     refresh_data = function(domain = self$domain){
                       self$initialize(self$account_id, domain)
                     })
                   , private = list(
                      limit_default = 10,
                      domain_default = "public",
                      dt_default = TRUE,
                      ord_default = "asc",
                      cursor_default = NULL,
                      min_amount = 1,
                      amount_per_trustline = 0.5
                   )
                   )
