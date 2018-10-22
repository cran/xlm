context("Pull data on the latest SDEX trades.")

n = 50

test_that("The first 50 trades from the network can be pulled.", {

  trades = getTrades(n, domain=domain)

  expect_type(trades, "list")
  expect_named(trades, c("_links", "_embedded"))
  expect_true(exists("records", trades[['_embedded']]))
  expect_lte(length(trades), n)

  expect_equal(unname(trades[['_links']][['self']]),
               sprintf(paste0("https://horizon-testnet.stellar.org/trades?",
                              "base_asset_code=&base_asset_issuer=&base_asset_type=&",
                              "counter_asset_code=&counter_asset_issuer=&counter_asset_type=&",
                              "cursor=&limit=%d&offer_id=&order=asc"), n))

})

test_that("Test data.table functionality.", {
  trades_df = expect_warning(getTrades(n, domain = domain, data.table = TRUE))$main_table
  expect_equal(nrow(trades_df), n)
  expect_true(is.data.table(trades_df))
  expect_true(all(c("offer_id", "paging_token", "id",
                    "base_asset_type", "counter_account") %in% names(trades_df)))
})


