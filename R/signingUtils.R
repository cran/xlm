#' Utilities for signing transactions
#' @noRd
#' @description to support the postTransaction() function.

digits <- function(x){
  return(as.numeric(charToRaw(as.character(x, b = 2))) - 48)
}

pad_digits <- function(x, y){

  digits_x = digits(x)
  digits_y = digits(y)
  len_x = length(digits_x)
  len_y = length(digits_y)
  mx = max(len_x, len_y)
  return(list(
    x = c(rep(0, mx - len_x), digits_x),
    y = c(rep(0, mx - len_y), digits_y)
  ))

}

bitAND <- function(x, y) {
  pd = pad_digits(x, y)
  return(return(paste0("0b", rawToChar(as.raw(1 * (pd$x & pd$y) + 48)))))
}

bitOR <- function(x, y) {
  pd = pad_digits(x, y)
  return(return(paste0("0b", rawToChar(as.raw(1 * (pd$x | pd$y) + 48)))))
}


