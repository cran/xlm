#' Utilities
#' @noRd
#' @description general internal functions essential for other functions.

.getRequest <- function(url, params = list()) {
  response = fromJSON(content(GET(url, query = params), as = "text"))
  return(.checkResponse(response))
}

.checkLimit <- function(l){
  limit_min = 1
  limit_max = 200
  # Returning NULL is preferable to returning NA.
  # NA gets parsed as a literal string by httr::GET.
  limit = as.integer(l)
  # API limit for records to return is 200 per page.
  if(is.na(limit) || limit < limit_min || limit > limit_max){
    limit = 10
    warning(sprintf("Limit must be a valid integer between %d and %d. The default of 10 was used for this request.",
                    limit_min, limit_max))
  }
  return(limit)
}

.checkCommonArgs <- function(cursor, limit, order){

  limit = .checkLimit(limit)

  if(is.na(order) || !(order %in% c("asc", "desc"))){
    order = "asc"
    warning("Order can only accept 'asc' or 'desc' as an input. The default of 'asc' was used for this request.")
  }

  if(is.null(cursor)){
    cursor = NA
  }
  if(is.na(cursor) || cursor == ""){
    cursor = ""
  }

  return(list(
    order = order,
    limit = limit,
    cursor = cursor
  ))
}

.checkSequence <- function(s){
  if (typeof(s) %in% c("double", "integer")){
    warning("Pass a string literal for operation ids, or set options(scipen=100), as the integer you provide may lose precision before the request is sent.")
  }
  attempt_conversion = suppressWarnings(as.integer(s))
  if(is.na(attempt_conversion)){
    stop("Could not convert the sequence provided to a valid integer.")
  }

  if(s == "0" || grepl("(^-[0-9]*|[0-9]+\\.[0-9]+)", s) || attempt_conversion <= 0){
    stop("The sequence number must be a whole number greater than 0.")
  }
  return(as.character(s))
}

.checkResponse <- function(response){
  response_names = names(response)
  error_headers = c("type", "title", "status", "detail")
  # https://www.stellar.org/developers/horizon/reference/errors.html
  if(all(response_names %in% error_headers)){
    stop(paste0("[", toupper(response_names), "] - ", response, collapse = "\n"))
  }
  return(response)
}

.cleanString <- function(chr){
  return(gsub("\\s+", "", tolower(chr)))
}
