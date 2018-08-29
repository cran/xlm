#' Creates and fund a new account on the test network.
#' @description Make a call to the Friendbot service on the test network and fund an account.
#'     Returns a JSON response.
#' @param account character - the public key of the account you wish to fund.
#' @return list
#' @export
#' @note https://www.stellar.org/developers/guides/get-started/create-account.html
#' @examples
#' friendbot("GAKYVLEN4MFPQ2R5Y4BA5RSJ7U5R2HGOK3VJ5PEUTLOHKTCBGCJZSHOS")

friendbot <- function(account){
  query_list = list(addr=account)
  return(.getRequest("https://friendbot.stellar.org/", query_list))
}
