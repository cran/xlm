#' Convert parsed JSON responses to a tabular format.
#' @description Takes a successful response containing multiple records and converts it into a table format.
#'     It works by flattening semi-structured lists into a table where it can.
#'     For example, if there are multiple signatures to a transaction then it will warn the user before moving those values to a separate table.
#' @param response list - the list object returned by the other xlm functions.
#' @return one or more data.tables
#' @export

listToDF <- function(response){

  # If the rows contain a price_r column, then parse it as an orderbook table.
  if(length(response)==0){
    return(list())
  }
  if(exists("price_r", response[[1]])){
    return(data.table(
      price_r_n = sapply(response, function(x){x[['price_r']]['n']}),
      price_r_d = sapply(response, function(x){x[['price_r']]['d']}),
      price = sapply(response, function(x){x['price']}),
      amount = sapply(response, function(x){x['amount']})
    ))
  }

  if(!exists("records", response[['_embedded']])) {
    stop("Records missing from the response - something went wrong.")
  }
  if(length(response[['_embedded']][['records']]) == 0){
    message("There were no records returned for this request.")
    return(data.table())
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
    if(all(find_nested_structures == 1)) return(NULL)
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
