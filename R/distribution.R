#' Gets the current XLM distribution stats.
#' @description Uses an API call from the Stellar dashboard to get the distribution figures.
#' @return list
#' @export
#' @note https://dashboard.stellar.org/
#' @examples
#' xlm_stats = distribution()

distribution <- function(){
  return(.getRequest("https://dashboard.stellar.org/api/lumens"))
}
