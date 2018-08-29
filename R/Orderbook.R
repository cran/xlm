#' Order book object.
#' @description An R6 class representing an orderbook on the Stellar network.
#'     It is initialized from the getOrderbook() function.
#' @exportClass
#' @field bids - a cryptographic signature of all of the data inside the ledger.
#' @field asks - the current sequence number of the ledger
#' @field base - how many transactions in the ledger.
#' @field counter - when the transaction was confirmed.
#' @field domain - character - signalling to query the testnet or public network. Can be either "testnet" or "public".
#' @field response - list containing the raw JSON response.
#' @note https://www.stellar.org/developers/horizon/reference/resources/orderbook.html

Orderbook <- R6Class("Orderbook",
                  public = list(
                    # fields
                    bids = NA,
                    asks = NA,
                    base = NA,
                    counter = NA,
                    response = NA,
                    domain = NA,
                    last_refreshed = NA,
                    # init
                    initialize = function(selling_asset_type,
                                          selling_asset_code = "",
                                          selling_asset_issuer = "",
                                          buying_asset_type,
                                          buying_asset_code = "",
                                          buying_asset_issuer = "",
                                          domain = private$domain_default){
                      response = getOrderbook(selling_asset_type = selling_asset_type,
                                              selling_asset_code = selling_asset_code,
                                              selling_asset_issuer = selling_asset_issuer,
                                              buying_asset_type = buying_asset_type,
                                              buying_asset_code = buying_asset_code,
                                              buying_asset_issuer = buying_asset_issuer,
                                              domain = domain)

                      self$bids = listToDF(response[['bids']])
                      self$asks = listToDF(response[['asks']])
                      self$base = response[['base']]
                      self$counter = response[['counter']]
                      self$domain = domain
                      self$response = response
                    },
                    # methods
                    refresh_data = function(domain = self$domain){
                      if(is.na(self$domain)) stop("You can't refresh an Orderbook object that hasn't been initialised yet.")

                      check_names = c('asset_code', 'asset_type')

                      predicate_base = check_names %in% names(self$base)
                      predicate_counter = check_names %in% names(self$counter)

                      selling_asset_type = self$base['asset_type']
                      selling_asset_code = ifelse(predicate_base, self$base['asset_code'], "")
                      selling_asset_issuer = ifelse(predicate_base, self$base['asset_issuer'], "")

                      buying_asset_type = self$counter['asset_type']
                      buying_asset_code = ifelse(predicate_counter, self$counter['asset_code'], "")
                      buying_asset_issuer = ifelse(predicate_counter, self$counter['asset_issuer'], "")

                      self$initialize(selling_asset_type = selling_asset_type,
                                      selling_asset_code = selling_asset_code,
                                      selling_asset_issuer = selling_asset_issuer,
                                      buying_asset_type = buying_asset_type,
                                      buying_asset_code = buying_asset_code,
                                      buying_asset_issuer = buying_asset_issuer,
                                      domain = self$domain)

                    })
                  , private = list(
                    domain_default = "public"
                  )
)
