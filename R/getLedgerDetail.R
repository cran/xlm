#' Returns a single ledger.
#' @description Return a single ledger by providing a sequence id.
#' @param sequence character - (required) a ledger id. Must be 1 or greater.
#' @param domain character - signalling to query the testnet or public network. Can be either "testnet" or "public".
#' @return list
#' @export
#' @note https://www.stellar.org/developers/horizon/reference/endpoints/ledgers-single.html
#' @examples
#' \dontrun{getLedgerDetail("1", "testnet")}

getLedgerDetail <- function(sequence, domain = "public") {
  url = .requestBuilder(endpoint = "ledgers",
                        id = .checkSequence(sequence),
                        domain = domain)
  return(.getRequest(url))
}
