context("Testing transaction details.")



good_hash = "9a9fec714911b74510fff65cc41aac2c466b3db1b548fa82323ba3516240be7a"
bad_hash = "123tooshort456"

test_that("Ids and hashes match on good hash.", {
  target_url = sprintf("https://horizon-testnet.stellar.org/transactions/%s", good_hash)
  t1 = getTransactionDetail(good_hash, domain = domain)
  expect_equal(target_url, as.character(t1[['_links']][['self']]))
  expect_equal(t1$id, good_hash)
  expect_equal(t1$hash, good_hash)
  expect_type(t1, "list")
  expect_true(all(c("_links", "id", "ledger", "created_at", "signatures") %in% names(t1)))
})

test_that("Bad hash returns an error.", {
  expect_error(getTransactionDetail(bad_hash, domain = domain),
               "The resource at the url requested was not found")
})



