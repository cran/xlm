context("Test the ticker.")

test_that("Data is returned as a named numeric value.", {
  valid_codes = c("USD", "USDT", "btc", "eTh", "BnB")
  for (code in valid_codes) {
    p = price(code)
    expect_named(p, toupper(code))
    expect_type(p, "double")
    expect_gt(p, 0)
  }
})

test_that("Errors around invalid codes are handled.", {
  expect_error(price("XRP"), "^Invalid currency code")
})
