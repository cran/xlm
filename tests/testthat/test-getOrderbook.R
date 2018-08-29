context("Test the orderbook functionality.")

type = "credit_alphanum4"
code = "SLT"
issuer = "GCKA6K5PCQ6PNF5RQBF7PQDJWRHO6UOGFMRLK3DYHDOI244V47XKQ4GP"

orderbook = getOrderbook(selling_asset_type = "native",
                         buying_asset_type = type,
                         buying_asset_code = code,
                         buying_asset_issuer = issuer)

test_that("An SLT orderbook can be returned successfully.", {

  expect_named(orderbook, c("bids", "asks", "base", "counter"))
  expect_equal(unname(orderbook$base), "native")

  counter = orderbook$counter
  expect_equal(unname(counter['asset_type']), type)
  expect_equal(unname(counter['asset_code']), code)
  expect_equal(unname(counter['asset_issuer']), issuer)

})

