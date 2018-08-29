#' Gets the current XLM price.
#' @description Make a call to the Binance API and get the current XLM market price.
#' @param currency character - current pairings are USD, ETH, BTC and BNB. USD is worked out indirectly via BTC with two API calls.
#' @param live boolean - if true, a while loop will continuously get the latest price and print it to the screen.
#' @return numeric
#' @export
#' @note Details of API can be found here: https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md
#' @examples
#' price("USD")

price <- function(currency = "USDT", live = FALSE) {

  currency_input = toupper(currency)

  if (!(currency_input %in% c("BTC", "ETH", "BNB", "USDT", "USD"))){
    stop(sprintf("Invalid currency code: %s. Must be in: USDT, USD, BTC, BNB or ETH.", currency))
  }

  currency = ifelse(currency == "USD", "USDT", currency_input)

  request_price = function(currency){
      url = "https://api.binance.com/api/v1/ticker/price"
      symbol = paste0("XLM", currency)
      response = content(GET(url = url,
                             query = list(symbol=symbol)))
      p_xlm = as.numeric(response$price)
      names(p_xlm) = currency_input
      return(p_xlm)
  }

  if(live){
    while(TRUE){
      p = request_price(currency)
      cat("\r", sprintf("Price in XLM/%s: %s", names(p)[1], p))
      Sys.sleep(1)
      flush.console()
    }
  } else {
    return(request_price(currency))
  }

}
