context("Testing operations from a specific account.")

valid_pk = "GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC"
invalid_pk = "GAGAGAGA"



test_that("Valid public key returns a 200 with the correct fields populated.", {
  a1 = getOperations_Account(valid_pk, domain = domain, data.table = FALSE)
  expect_false(is.data.table(a1))
  expect_equal(as.character(a1[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s/operations?cursor=&limit=10&order=asc", valid_pk))
  expect_named(a1, c("_links", "_embedded"))
  expect_true(exists("records", a1[['_embedded']]))
})

test_that("Valid account can also return a data.table.", {
  a2 = getOperations_Account(valid_pk, domain = domain)
  expect_true(is.data.table(a2))
  expect_gte(nrow(a2), 1)
  expect_true(all(c("account", "created_at", "funder", "type", "transaction_hash", "id") %in% names(a2)))
})

test_that("Parameters can be tuned.", {
  target_url = sprintf("https://horizon-testnet.stellar.org/accounts/%s/operations?cursor=&limit=56&order=desc", valid_pk)
  a3 = getOperations_Account(valid_pk, domain = domain, data.table = FALSE,
                             limit = 56, order = "desc")
  expect_equal(as.character(a3[['_links']][['self']]), target_url)
})

test_that("Error handling for bad public key.", {
  expect_error(getOperations_Account(invalid_pk, domain = domain))
})
