#' Get an overview of account operations on the Stellar ledger.
#' @description Returns all operations that were included in valid transactions that affected a particular account. Converts the JSON response to a list.
#' @param pk character - your Stellar account/wallet address (public key.)
#' @param cursor numeric - optional, a paging token - where to start from. Can also be "now".
#' @param limit numeric - optional, the number of records to return. Default is 10.
#' @param order character - optional, "asc" or "desc"
#' @param data.table boolean - if TRUE, a data.table is returned. If FALSE or NULL, a list is returned.
#' @param domain character - signalling to query the testnet or public network. Can be either "testnet" or "public".
#' @return data.table (default) or list
#' @export
#' @note https://www.stellar.org/developers/horizon/reference/endpoints/operations-for-account.html
#' @examples
#' \donttest{getOperations_Account("GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC")}

getOperations_Account <- function(pk, cursor = NULL, limit = 10, order = "asc", data.table = TRUE, domain = "public"){
  request = .requestBuilder("accounts", resource = "operations", id = pk, domain = domain)
  query_list = .checkCommonArgs(order=order,
                           cursor=cursor,
                           limit=limit)
  response = .getRequest(request, query_list)
  if(data.table){
    return(listToDF(response))
  }
  return(response)
}
