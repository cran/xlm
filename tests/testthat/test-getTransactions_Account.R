context("Find transactions attached to a specific account.")

valid_pk = test_account_1 # from helper-config
invalid_pk = "Lord Almighty, I feel my temperature rising."

test_that("Valid public key returns a 200 with the correct fields populated.", {
  t1 = getTransactions_Account(valid_pk, domain = domain, data.table = FALSE)
  expect_false(is.data.table(t1))
  expect_equal(as.character(t1[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s/transactions?cursor=&limit=10&order=asc", valid_pk))
  expect_named(t1, c("_links", "_embedded"))
  expect_true(exists("records", t1[['_embedded']]))
})

test_that("Valid account can also return a data.table.", {
  t2 = getTransactions_Account(valid_pk, domain = domain)
  expect_true(is.data.table(t2))
  expect_true(all(c("created_at", "ledger", "hash", "signatures", "id", "memo_type", "fee_paid") %in% names(t2)))
  expect_gte(nrow(t2), 1)
})

test_that("Parameters can be tuned.", {
  target_url = sprintf("https://horizon-testnet.stellar.org/accounts/%s/transactions?cursor=&limit=199&order=desc", valid_pk)
  t3 = getTransactions_Account(valid_pk, domain = domain, data.table = FALSE,
                           limit = 199,
                           order = "desc")
  expect_equal(as.character(t3[['_links']][['self']]),
               target_url)
})

test_that("Error handling for bad public key.", {
  expect_error(getTransactions_Account(invalid_pk, domain = domain, data.table = FALSE))
})
