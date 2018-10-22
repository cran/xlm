context("Find effects attached to a specific account.")

valid_pk = test_account_1 # from helper-config
invalid_pk = "GAGAGAfsdafsadGA"

test_that("Valid public key returns a 200 with the correct fields populated.", {
  e1 = getEffects_Account(valid_pk, domain = domain, data.table = FALSE)
  expect_false(is.data.table(e1))
  expect_equal(as.character(e1[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s/effects?cursor=&limit=10&order=asc", valid_pk))
  expect_named(e1, c("_links", "_embedded"))
  expect_true(exists("records", e1[['_embedded']]))
})

test_that("Valid account can also return a data.table.", {
  e2 = getEffects_Account(valid_pk, domain = domain)
  expect_true(is.data.table(e2))
  expect_true(all(c("starting_balance", "id", "type", "weight") %in% names(e2)))
  expect_gte(nrow(e2), 2)
})

test_that("Parameters can be tuned.", {
  target_url = sprintf("https://horizon-testnet.stellar.org/accounts/%s/effects?cursor=&limit=99&order=desc", valid_pk)
  e3 = getEffects_Account(valid_pk, domain = domain, data.table = FALSE,
                         limit = 99,
                         order = "desc")
  expect_equal(as.character(e3[['_links']][['self']]),
               target_url)
})

test_that("Error handling for bad public key.", {
  expect_error(getEffects_Account(invalid_pk, domain = domain, data.table = FALSE),
               "resource at the url requested was not found")
})
