context("Pull pre-calculated trade aggregations.")

n = 5

start_time="1517521726000"
end_time="1517532526000"
resolution="3600000"

counter_asset_type = "credit_alphanum4"
counter_asset_code="SLT"
counter_asset_issuer = "GCKA6K5PCQ6PNF5RQBF7PQDJWRHO6UOGFMRLK3DYHDOI244V47XKQ4GP"

domain = "public"

ta = getTradeAggregations(
  start_time = start_time,
  end_time = end_time,
  resolution = resolution,
  limit = n,
  order = "asc",
  base_asset_type = "native",
  counter_asset_type = counter_asset_type,
  counter_asset_code = counter_asset_code,
  counter_asset_issuer = counter_asset_issuer,
  domain = domain
)

test_that("The first n trades from the network can be pulled and arrive aggregated.", {

  expect_type(ta, "list")
  expect_named(ta, c("_links", "_embedded"))
  expect_true(exists("records", ta[['_embedded']]))

  target_url = sprintf(
    paste0("https://horizon.stellar.org/trade_aggregations?",
           "start_time=%s&end_time=%s&resolution=%s&limit=%d&order=asc&",
           "base_asset_type=native&base_asset_code=&base_asset_issuer=&",
           "counter_asset_type=%s&counter_asset_code=%s&counter_asset_issuer=%s"),
    start_time,
    end_time,
    resolution,
    n,
    counter_asset_type,
    counter_asset_code,
    counter_asset_issuer
  )

  expect_equal(unname(ta[['_links']][['self']]), target_url)

})

test_that("data.table can be generated from the result for trade aggregations.", {

  ta_df = getTradeAggregations(
    start_time = start_time,
    end_time = end_time,
    resolution = resolution,
    limit = n,
    order = "asc",
    base_asset_type = "native",
    counter_asset_type = counter_asset_type,
    counter_asset_code = counter_asset_code,
    counter_asset_issuer = counter_asset_issuer,
    domain = domain,
    data.table = TRUE
  )

  expect_true(is.data.table(ta_df))
  expect_equal(nrow(ta_df), length(ta[['_embedded']][['records']]))
  expect_true(all(c("timestamp", "trade_count", "avg", "high", "low", "open", "close") %in% names(ta_df)))

})



