#' Returns all payments.
#' @description Return all payments operations that are a part of a valid transaction.
#' @param cursor numeric - optional, a paging token - where to start from. Can also be "now".
#' @param limit numeric - the number of records to return. Default is 10.
#' @param order character - optional, "asc" or "desc"
#' @param data.table boolean - if TRUE, a data.table is returned. If FALSE or NULL, a list is returned.
#' @param domain character - signalling to query the testnet or public network. Can be either "testnet" or "public". boolean - if TRUE, a data.table is overwritten and the server-side streaming capability is utilised. A list will be returned.
#' @return data.table or list
#' @export
#' @note https://www.stellar.org/developers/horizon/reference/endpoints/payments-all.html
#' @examples
#' getPayments(20, domain = "testnet")

getPayments <- function(limit, cursor = NULL, order = "asc", data.table = TRUE, domain = "public"){
  request = .requestBuilder("payments", domain = domain)
  query_list = .checkCommonArgs(order=order,
                                cursor=cursor,
                                limit=limit)
  response = .getRequest(request, query_list)
  if(data.table){
    return(listToDF(response))
  }
  return(response)
}
