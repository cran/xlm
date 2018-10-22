#' Find a payment path between a source and a destination.
#' @description Calculate a path for a payment based on the assets the source/target owns.
#' @param destination_account character - The destination account that any returned path should use.
#' @param destination_asset_type character - The type of the destination asset	credit_alphanum4
#' @param destination_asset_code character - The code for the destination, if destination_asset_type is not “native”.
#' @param destination_asset_issuer character - The issuer for the destination, if destination_asset_type is not “native”.
#' @param destination_amount character - The amount, denominated in the destination asset, that any returned path should be able to satisfy.
#' @param source_account character - The sender’s account id. Any returned path must use a source that the sender can hold.
#' @param domain - character - signalling to query the testnet or public network. Can be either "testnet" or "public".
#' @return list
#' @export
#' @note https://www.stellar.org/developers/horizon/reference/endpoints/path-finding.html

findPaymentPath <- function(destination_account,
                            destination_asset_type,
                            destination_asset_code,
                            destination_asset_issuer,
                            destination_amount,
                            source_account,
                            domain = "public"){
  url = .requestBuilder("paths", domain = domain)
  query_list = list(
    destination_account = destination_account,
    destination_asset_type = destination_asset_type,
    destination_asset_code = destination_asset_code,
    destination_asset_issuer = destination_asset_issuer,
    destination_amount = destination_amount,
    source_account = source_account
  )
  return(.getRequest(url, query_list))
}


