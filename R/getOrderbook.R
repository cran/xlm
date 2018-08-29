#' Returns details on the current state of the order book
#' @description Return a summary of assets bought and sold on the ledger.
#' @param selling_asset_type	required, character - Type of the Asset being sold	native
#' @param selling_asset_code	optional, character - code of the Asset being sold	USD
#' @param selling_asset_issuer	optional, character - account ID of the issuer of the Asset being sold	GA2HGBJIJKI6O4XEM7CZWY5PS6GKSXL6D34ERAJYQSPYA6X6AI7HYW36
#' @param buying_asset_type	required, character - type of the Asset being bought	credit_alphanum4
#' @param buying_asset_code	optional, character - code of the Asset being bought	BTC
#' @param buying_asset_issuer	optional, character - account ID of the issuer of the Asset being bought
#' @param domain character - signalling to query the testnet or public network. Can be either "testnet" or "public".
#' @return list
#' @export
#' @note https://www.stellar.org/developers/horizon/reference/endpoints/orderbook-details.html
#' @examples
#' \donttest{getOrderbook(selling_asset_type = "native", buying_asset_type = "credit_alphanum4")}

getOrderbook <- function(selling_asset_type,
                         selling_asset_code = "",
                         selling_asset_issuer = "",
                         buying_asset_type,
                         buying_asset_code = "",
                         buying_asset_issuer = "",
                         domain = "public") {

  if(selling_asset_type == "native" && buying_asset_type == "native"){
    stop("There are no markets for XLM/XLM.")
  }
  if(selling_asset_code == buying_asset_code){
    stop("The buying and selling codes should not be the same.")
  }

  request = .requestBuilder("order_book", domain = domain)

  query_list = list(
    limit = 200,
    selling_asset_type = selling_asset_type,
    selling_asset_code = selling_asset_code,
    selling_asset_issuer = selling_asset_issuer,
    buying_asset_type = buying_asset_type,
    buying_asset_code = buying_asset_code,
    buying_asset_issuer = buying_asset_issuer
  )

  return(.getRequest(request, query_list))
}


