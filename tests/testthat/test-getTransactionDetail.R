context("getTransactionDetail")

bad_hash = "123tooshort456"

test_that("Bad hash returns an error.", {
  expect_error(getTransactionDetail(bad_hash, domain = domain),
               "The resource at the url requested was not found")
})



