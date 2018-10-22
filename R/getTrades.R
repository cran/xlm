#' Returns data on trades.
#' @description Return all partially fulfilled trades to buy or sell assets on the ledger.
#' @param cursor numeric - optional, a paging token - where to start from. Can also be "now".
#' @param limit numeric - the number of records to return.
#' @param order character - optional, "asc" or "desc"
#' @param base_asset_type	optional, string - type of base asset
#' @param base_asset_code	optional, string - code of base asset, not required if type is native
#' @param base_asset_issuer	optional, string - issuer of base asset, not required if type is native
#' @param counter_asset_type	optional, string - type of counter asset
#' @param counter_asset_code	optional, string - code of counter asset, not required if type is native
#' @param counter_asset_issuer	optional, string - issuer of counter asset, not required if type is native
#' @param offer_id	optional, string - filter for by a specific offer id
#' @param data.table boolean - if true, a data.table is returned. FALSE by default.
#' @param domain - character - signalling to query the testnet or public network. Can be either "testnet" or "public".
#' @return data.table or list
#' @export
#' @note https://www.stellar.org/developers/horizon/reference/endpoints/trades.html
#' @examples
#' \dontrun{getTrades(20)}

getTrades <- function(limit, cursor = NULL, order = "asc", domain = "public",
                      base_asset_type = "", base_asset_code = "", base_asset_issuer = "",
                      counter_asset_type  = "", counter_asset_code = "",
                      counter_asset_issuer = "", offer_id = "", data.table = FALSE){
  request = .requestBuilder(endpoint="trades", domain = domain)
  query_list = list(
      cursor = cursor,
      limit = limit,
      order = order,
      base_asset_type = base_asset_type,
      base_asset_code = base_asset_code,
      base_asset_issuer = base_asset_issuer,
      counter_asset_type = counter_asset_type,
      counter_asset_code	= counter_asset_code,
      counter_asset_issuer = counter_asset_issuer,
      offer_id	= offer_id
    )
  response = .getRequest(request, query_list)
  if(data.table){
    return(listToDF(response))
  }
  return(response)
}

