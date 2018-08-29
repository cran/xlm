#' Returns all assets.
#' @description Return all assets in the system with statistics.
#' @param asset_code character - (optional) code of the asset to filter by
#' @param asset_issuer character - (optional) issuer of the asset to filter by
#' @param cursor numeric - optional, a paging token - where to start from. Can also be "now".
#' @param limit numeric - the number of records to return. Default is 10.
#' @param order character - optional, "asc" or "desc"
#' @param data.table boolean - if TRUE, a data.table is returned. If FALSE or NULL, a list is returned.
#' @param domain character - signalling to query the testnet or public network. Can be either "testnet" or "public". boolean - if TRUE, a data.table is overwritten and the server-side streaming capability is utilised. A list will be returned.
#' @return list
#' @export
#' @note https://www.stellar.org/developers/horizon/reference/endpoints/assets-all.html
#' @examples
#' getAssets(10, domain = "testnet")

getAssets <- function(limit, cursor = NULL, asset_code = "", asset_issuer = "", order = "asc", data.table = TRUE, domain = "public"){
  request = .requestBuilder("assets", domain = domain)
  query_list = .checkCommonArgs(order=order,
                                cursor=cursor,
                                limit=limit)
  query_list[[4]] = asset_code
  query_list[[5]] = asset_issuer
  names(query_list)[4:5] = c("asset_code", "asset_issuer")

  response = .getRequest(request, query_list)
  if(data.table){
    return(listToDF(response))
  }
  return(response)
}
