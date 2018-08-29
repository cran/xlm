context("Find transactions attached to a specific ledger.")

valid_sequence = "10568629"
invalid_sequence = 0



test_that("Valid public key returns a 200 with the correct fields populated.", {
  t1 = getTransactions_Ledger(valid_sequence, domain = domain, data.table = FALSE)
  expect_false(is.data.table(t1))
  expect_equal(as.character(t1[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/ledgers/%s/transactions?cursor=&limit=10&order=asc", valid_sequence))
  expect_named(t1, c("_links", "_embedded"))
  expect_true(exists("records", t1[['_embedded']]))
})

test_that("Valid ledger can also return a data.table.", {
  t2 = getTransactions_Ledger(valid_sequence, domain = domain)
  expect_true(is.data.table(t2))
  expect_true(all(c("created_at", "ledger", "hash", "signatures",
                    "id", "memo_type", "fee_paid") %in% names(t2)))
  expect_gte(nrow(t2), 3)
})

test_that("Parameters can be tuned.", {
  target_url = sprintf("https://horizon-testnet.stellar.org/ledgers/%s/transactions?cursor=&limit=33&order=desc", valid_sequence)
  t3 = getTransactions_Ledger(valid_sequence, domain = domain, data.table = FALSE,
                           limit = 33,
                           order = "desc")
  expect_equal(as.character(t3[['_links']][['self']]),
               target_url)
})

test_that("Error handling for bad public key.", {
  expect_error(
    expect_warning(getTransactions_Ledger(invalid_sequence, domain = domain, data.table = FALSE),
                   "Pass a string literal"),
    "The sequence number must be a whole number greater than 0.")
})
