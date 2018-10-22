#' Convert parsed JSON responses to a tabular format.
#' @description Takes a successful response containing multiple records and converts it into a table format.
#'     It works by flattening semi-structured lists into a table where it can.
#'     For example, if there are multiple signatures to a transaction then it will warn the user before moving those values to a separate table.
#' @param response list - the list object returned by the other xlm functions.
#' @return one or more data.tables
#' @export

listToDF <- function(response){

  # Error handling.
  if(length(response)==0){
    return(list())
  }
  if(!exists("records", response[['_embedded']])) {
    stop("Records missing from the response - something went wrong.")
  }
  if(!exists("_links", response)) {
    stop("Links missing from the response - something went wrong.")
  }
  if(length(response[['_embedded']][['records']]) == 0){
    message("There were no records returned for this request.")
    return(data.table())
  }

  is_trade_agg = grepl("/trade_aggregations", response[['_links']][['self']])
  # If trades endpoint is called, just return a simple data.table.
  if(is_trade_agg){
    dta = response[['_embedded']][['records']]
    extract = function(x) sapply(dta, function(i) i[[x]])
    return(data.table(
      timestamp = extract('timestamp'),
      trade_count = as.numeric(extract('trade_count')),
      base_volume = as.numeric(extract('base_volume')),
      counter_volume = as.numeric(extract('counter_volume')),
      avg = as.numeric(extract('avg')),
      high = as.numeric(extract('high')),
      high_r_n = sapply(dta, function(x) x[['high_r']][['N']]),
      high_r_d = sapply(dta, function(x) x[['high_r']][['D']]),
      low = as.numeric(extract('low')),
      low_r_n = sapply(dta, function(x) x[['low_r']][['N']]),
      low_r_d = sapply(dta, function(x) x[['low_r']][['D']]),
      open = as.numeric(extract('open')),
      open_r_n = sapply(dta, function(x) x[['open_r']][['N']]),
      open_r_d = sapply(dta, function(x) x[['open_r']][['D']]),
      close = as.numeric(extract('close')),
      close_r_n = sapply(dta, function(x) x[['close_r']][['N']]),
      close_r_d = sapply(dta, function(x) x[['close_r']][['D']])
    ))
  }

  records = response[['_embedded']][['records']]
  records_no_links = lapply(records, function(r){
    r[['_links']] = NULL
    return(r)
  })

  unpivoted = lapply(records_no_links, function(record){
    # Create a vector of the lengths of each field. We want to unpivot the fields with more than 1 value.
    find_nested_structures = sapply(record, length)
    # If they are all uniform, append the record to the outer table and move on.
    if(all(find_nested_structures == 1) || is_trade_agg) return(NULL)
    inds = which(find_nested_structures > 1)
    return(data.table(
      # Take the id of the record to use as a private key, extract the data and create a list of data.tables for the row.
      # If id doesn't exist, then it is probably referring to assets.
      id = ifelse(is.null(record$id), record$asset_code, record$id),
      field = rep(names(record)[inds], find_nested_structures[inds]),
      value = unlist(record[inds])
    ))
  })
  unpivoted = rbindlist(unpivoted)

  flattened_df = lapply(records_no_links, function(record){
    # Repeated code, not ideal, but seems to be the cleanest way to do this.
    find_nested_structures = sapply(record, length)
    # If all fields are uniform, return the row asis.
    if(all(find_nested_structures == 1)) return(record)
    inds = which(find_nested_structures > 1)
    # Nullify any rows where there are more than one entry. This can be joined back later.
    record[inds] = NULL
    return(record)
  })

  if(nrow(unpivoted) == 0){
    return(rbindlist(flattened_df, fill=TRUE))
  }
  warning("The data returned contained nested structures.\n",
          "These have been split out into a separate table and two tables will be returned in total.\n",
          "You can join them back on using the 'id' column in both tables. These values will appear as NA in the main table.")

  return(list(
    main_table = rbindlist(flattened_df, fill=TRUE),
    lookup_table = unpivoted
  ))

}
