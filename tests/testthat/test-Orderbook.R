context("Testing the Orderbook class object.")

type = "credit_alphanum4"
code = "SLT"
issuer = "GCKA6K5PCQ6PNF5RQBF7PQDJWRHO6UOGFMRLK3DYHDOI244V47XKQ4GP"

orderbook = Orderbook$new(selling_asset_type = "native",
                          buying_asset_type = type,
                          buying_asset_code = code,
                          buying_asset_issuer = issuer,
                          domain = domain)

test_that("Orderbooks can be initialised successfully.", {

  expect_true(is.R6Class(Orderbook))
  expect_true(Orderbook$class)
  expect_equal(Orderbook$classname, "Orderbook")
  expect_type(orderbook$response$asks, "list")
  expect_type(orderbook$response$bids, "list")

})

test_that("Errors caught when initialised incorrectly.", {
  expect_error(Orderbook$new(selling_asset_type = "native",
                             buying_asset_type = "native"))
  expect_error(Orderbook$new(selling_asset_type = "credit_alphanum4",
                             buying_asset_type = "credit_alphanum4",
                             selling_asset_code = "SLT",
                             buying_asset_code = "SLT"))
  expect_error(Orderbook$new(selling_asset_type = "native",
                             buying_asset_type = "credit_alphanum4"))

})
