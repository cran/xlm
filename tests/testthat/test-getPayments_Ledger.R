context("Find payments attached to a specific ledger.")

valid_sequence = "10568629"
invalid_sequence = 0



test_that("Valid public key returns a 200 with the correct fields populated.", {
  p1 = getPayments_Ledger(valid_sequence, domain = domain, data.table = FALSE)
  expect_false(is.data.table(p1))
  expect_equal(as.character(p1[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/ledgers/%s/payments?cursor=&limit=10&order=asc", valid_sequence))
  expect_named(p1, c("_links", "_embedded"))
  expect_true(exists("records", p1[['_embedded']]))
})

test_that("Valid ledger can also return a data.table.", {
  p2 = getPayments_Ledger(valid_sequence, domain = domain)
  expect_true(is.data.table(p2))
  expect_true(all(c("created_at", "type_i", "from", "to",
                    "source_account", "transaction_hash",
                    "id", "amount") %in% names(p2)))
  expect_equal(nrow(p2), 1)
})

test_that("Parameters can be tuned.", {
  target_url = sprintf("https://horizon-testnet.stellar.org/ledgers/%s/payments?cursor=&limit=66&order=desc", valid_sequence)
  p3 = getPayments_Ledger(valid_sequence, domain = domain, data.table = FALSE,
                         limit = 66,
                         order = "desc")
  expect_equal(as.character(p3[['_links']][['self']]),
               target_url)
})

test_that("Error handling for bad public key.", {
  expect_error(
    expect_warning(getPayments_Ledger(invalid_sequence, domain = domain, data.table = FALSE),
                   "Pass a string literal"),
    "The sequence number must be a whole number greater than 0.")
})
