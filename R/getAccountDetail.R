#' Get an overview of an account on the Stellar ledger.
#' @description Query the accounts endpoint, specifying no extra resources. Converts the JSON response to a list.
#' @param pk character - your Stellar account address (also known as a public key.)
#' @param data character - if the Stellar account has data key-value pairs assigned to it, pass the key name to get the value.
#'     The internal request builder will attempt to parse the key to ASCII if it contains any non-ASCII characters.
#' @param domain character - signalling to query the testnet or public network. Can be either "testnet" or "public".
#' @return list or Account class.
#' @note https://www.stellar.org/developers/horizon/reference/endpoints/accounts-single.html
#' @examples
#' getAccountDetail("GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC")

getAccountDetail <- function(pk, data = NA, domain = "public"){
  request = .requestBuilder("accounts", id = pk, key = data, domain = domain)
  response = .getRequest(request)
  if(!is.null(response[['status']])) {
    if(response[['status']] == 400) stop(response)
  }
  return(response)
}
