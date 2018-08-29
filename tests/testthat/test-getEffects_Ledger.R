context("Find effects attached to a specific ledger.")

valid_sequence = "10568629"
invalid_sequence = 0



test_that("Valid public key returns a 200 with the correct fields populated.", {
  e1 = getEffects_Ledger(valid_sequence, domain = domain, data.table = FALSE)
  expect_false(is.data.table(e1))
  expect_equal(as.character(e1[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/ledgers/%s/effects?cursor=&limit=10&order=asc", valid_sequence))
  expect_named(e1, c("_links", "_embedded"))
  expect_true(exists("records", e1[['_embedded']]))
})

test_that("Valid account can also return a data.table.", {
  e2 = getEffects_Ledger(valid_sequence, domain = domain)
  expect_true(is.data.table(e2))
  expect_true(all(c("created_at", "id", "type", "account", "asset_type") %in% names(e2)))
  expect_equal(nrow(e2), 2)
})

test_that("Parameters can be tuned.", {
  target_url = sprintf("https://horizon-testnet.stellar.org/ledgers/%s/effects?cursor=&limit=101&order=desc", valid_sequence)
  e3 = getEffects_Ledger(valid_sequence, domain = domain, data.table = FALSE,
                         limit = 101,
                         order = "desc")
  expect_equal(as.character(e3[['_links']][['self']]),
               target_url)
})

test_that("Error handling for bad public key.", {
  expect_error(
    expect_warning(getEffects_Ledger(invalid_sequence, domain = domain, data.table = FALSE),
                   "Pass a string literal"),
               "The sequence number must be a whole number greater than 0.")
})
