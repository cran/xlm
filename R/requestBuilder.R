#' Build requests to send to the Horizon API
#' @noRd
#' @description A generic function to build requests before querying the API.
#' @param domain character - signalling to query the testnet or public network. Can be either "testnet" or "public".
#' @param endpoint string - the name of the Horizon endpoint. https://www.stellar.org/developers/reference/
#' @param resource string - (optional) the name of the resource.
#' @param id character - could be an account id, or a ledger sequence, or a transaction hash.
#' @param key character - the lowest granularity for a request. Rarely used (only for retrieving data on Stellar accounts.)
#' @return character - a fully formed url.

.requestBuilder <- function(endpoint, domain = "public", resource = NA, id = NA, key = NA) {

  if(missing(endpoint)){
    stop("The endpoint parameter has been supplied incorrectly.")
  }

  if(!(domain %in% c("public", "testnet"))){
    stop("The domain parameter has been supplied incorrectly. It must be either 'testnet' or 'public'.")
  }
  network = ifelse(domain == "public", "horizon.stellar.org", "horizon-testnet.stellar.org")

  # Most endpoints have simple URL constructions.
  if(endpoint %in% c("assets", "effects", "trade_aggregations", "payments", "trades", "paths", "order_book")){
    return(sprintf("https://%s/%s", network, endpoint))
  }

  # Accounts have a number if rules to be applied for a valid query.
  if(endpoint == "accounts"){
    if(is.na(id)){
      stop("For retrieving accounts, an account id must be specified.")
    }
    account_resources = c("effects", "offers", "operations", "payments", "transactions")
    if (!is.na(resource)) {
      if (resource == "data" && !is.na(key)) {
        return(sprintf("https://%s/accounts/%s/data/%s", network, id, URLencode(key)))
      }
      if (resource %in% account_resources) {
        return(sprintf("https://%s/accounts/%s/%s", network, id, resource))
      }
    }
    return(sprintf("https://%s/accounts/%s", network, id))
  }

  # Constructing the transaction URLs require some logic, but not too much.
  if(endpoint == "transactions"){
    txn_resources = c("effects", "operations", "payments")
    if (!is.na(id)) {
      if (resource %in% txn_resources) {
        return(sprintf("https://%s/transactions/%s/%s", network, id, resource))
      }
      return(sprintf("https://%s/transactions/%s", network, id))
    }
    return(sprintf("https://%s/transactions", network))
  }

  # Ditto for operations.
  if(endpoint == "operations"){
    if (!is.na(id)) {
      return(sprintf("https://%s/operations/%s", network, id))
    }
    return(sprintf("https://%s/operations", network))
  }

  # Ledgers require a bit more logic.
  if(endpoint == "ledgers"){

    ledger_resources = c("effects", "operations", "payments", "transactions")

    if (!is.na(id)) {
      if (resource %in% ledger_resources) {
        return(sprintf("https://%s/ledgers/%s/%s", network, id, resource))
      }
      return(sprintf("https://%s/ledgers/%s", network, id))
    }
    return(sprintf("https://%s/ledgers", network))
  }

  stop("Unknown endpoint specified. Double check that the endpoint you are trying to access exists, or that this library supports it. https://www.stellar.org/developers/reference/")

}
