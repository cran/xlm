#' Get an overview of transaction effects for a specific transaction.
#' @description Returns effect details for a specific transaction on the ledger. Converts the JSON response to a list.
#' @param hash character - the transaction id.
#' @param cursor numeric - optional, a paging token - where to start from. Can also be "now".
#' @param limit numeric - optional, the number of records to return. Default is 10.
#' @param order character - optional, "asc" or "desc"
#' @param data.table boolean - if TRUE, a data.table is returned. If FALSE or NULL, a list is returned.
#' @param domain character - signalling to query the testnet or public network. Can be either "testnet" or "public".
#' @return data.table (by default) or list
#' @export
#' @note https://www.stellar.org/developers/horizon/reference/endpoints/effects-for-transaction.html
#' @examples
#' \donttest{getEffects_Transaction("SomeTxnHash")}

getEffects_Transaction <- function(hash, cursor = NULL, limit = 10, order = "asc", data.table = TRUE, domain = "public"){
  request = .requestBuilder("transactions", resource = "effects", id = hash, domain = domain)
  query_list = .checkCommonArgs(order=order,
                                cursor=cursor,
                                limit=limit)
  response = .getRequest(request, query_list)
  if(data.table){
    return(listToDF(response))
  }
  return(response)
}
