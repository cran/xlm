context("Testing operations from a specific ledger.")

valid_sequence = "10568629"
invalid_sequence = 0



test_that("Valid public key returns a 200 with the correct fields populated.", {
  a1 = getOperations_Ledger(valid_sequence, domain = domain, data.table = FALSE)
  expect_false(is.data.table(a1))
  expect_equal(as.character(a1[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/ledgers/%s/operations?cursor=&limit=10&order=asc", valid_sequence))
  expect_named(a1, c("_links", "_embedded"))
  expect_true(exists("records", a1[['_embedded']]))
})

test_that("Valid account can also return a data.table.", {
  a2 = expect_warning(getOperations_Ledger(valid_sequence, domain = domain))
  expect_true(is.data.table(a2$main_table))
  expect_type(a2, "list")
  expect_equal(nrow(a2$main_table), 3)
  expect_equal(nrow(a2$lookup_table), 4)
  expect_true(all(c("source_account", "asset_type", "to",
                    "from", "type", "transaction_hash", "id") %in% names(a2$main_table)))
})

test_that("Parameters can be tuned.", {
  target_url = sprintf("https://horizon-testnet.stellar.org/ledgers/%s/operations?cursor=&limit=56&order=desc", valid_sequence)
  a3 = getOperations_Ledger(valid_sequence, domain = domain, data.table = FALSE,
                             limit = 56, order = "desc")
  expect_equal(as.character(a3[['_links']][['self']]), target_url)
})

test_that("Error handling for bad public key.", {
  expect_error(
    expect_warning(getOperations_Ledger(invalid_sequence, domain = domain, data.table = FALSE),
                   "Pass a string literal"),
    "The sequence number must be a whole number greater than 0.")
})
