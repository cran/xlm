#' Returns a single valid transactions.
#' @description Return a single transaction using a transaction id.
#' @param hash character - a transaction id/hash.
#' @param domain character - signalling to query the testnet or public network. Can be either "testnet" or "public".
#' @return list
#' @export
#' @note https://www.stellar.org/developers/horizon/reference/endpoints/transactions-single.html
#' @examples
#' \donttest{getTransactionDetail("someHash")}

getTransactionDetail <- function(hash, domain = "public"){
  request = .requestBuilder("transactions", id = hash, domain = domain)
  return(.getRequest(request))
}
