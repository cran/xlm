context("Find payments attached to a specific account.")

valid_pk = test_account_1 # from helper-config
invalid_pk = "¯\\_(ツ)_/¯"

test_that("Valid public key returns a 200 with the correct fields populated.", {
  p1 = getPayments_Account(valid_pk, domain = domain, data.table = FALSE)
  expect_false(is.data.table(p1))
  expect_equal(as.character(p1[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s/payments?cursor=&limit=10&order=asc", valid_pk))
  expect_named(p1, c("_links", "_embedded"))
  expect_true(exists("records", p1[['_embedded']]))
})

test_that("Valid account can also return a data.table.", {
  p2 = getPayments_Account(valid_pk, domain = domain)
  expect_true(is.data.table(p2))
  expect_true(all(c("created_at", "type_i", "funder", "transaction_hash", "id") %in% names(p2)))
  expect_gte(nrow(p2), 1)
})

test_that("Parameters can be tuned.", {
  target_url = sprintf("https://horizon-testnet.stellar.org/accounts/%s/payments?cursor=&limit=102&order=desc", valid_pk)
  p3 = getPayments_Account(valid_pk, domain = domain, data.table = FALSE,
                         limit = 102,
                         order = "desc")
  expect_equal(as.character(p3[['_links']][['self']]),
               target_url)
})

test_that("Error handling for bad public key.", {
  expect_error(getPayments_Account(invalid_pk, domain = domain, data.table = FALSE),
               "resource at the url requested was not found")
})
