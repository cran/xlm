#' Post a transaction.
#' @description Posts a new transaction to the Stellar Network.
#' @param body character - base64 representation of transaction envelope XDR.
#' @param domain - character - signalling to query the testnet or public network. Can be either "testnet" or "public".
#' @return list
#' @export
#' @note https://www.stellar.org/developers/horizon/reference/endpoints/transactions-create.html
#' @examples
#' \dontrun{postTransaction("aaaaaafds098as0d9")}
#'
postTransaction <- function(body, domain = "public"){
  url = .requestBuilder("transactions",
                        domain = domain)
  response = content(POST(url, query=list(tx=URLencode(body))), as = "text")
  return(fromJSON(response))
}

