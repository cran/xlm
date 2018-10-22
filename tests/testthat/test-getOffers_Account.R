context("Find offers being made by a specific account on the SDEX.")

valid_pk = test_account_1 # from helper-config
invalid_pk = "GAGAGAGA"

test_that("Valid public key returns a 200 with the correct fields populated.", {
  a1 = getOffers_Account(valid_pk, domain = domain, data.table = FALSE)
  expect_false(is.data.table(a1))
  expect_equal(as.character(a1[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s/offers?cursor=&limit=10&order=asc", valid_pk))
  expect_named(a1, c("_links", "_embedded"))
  expect_true(exists("records", a1[['_embedded']]))
})

test_that("Valid account can also return a data.table.", {
  # TODO: find a good example/sample data where
  a2 = getOffers_Account(valid_pk, domain = domain)
  expect_true(is.data.table(a2))
})

test_that("Parameters can be tuned.", {
  target_url = sprintf("https://horizon-testnet.stellar.org/accounts/%s/offers?cursor=&limit=56&order=desc", valid_pk)
  a3 = getOffers_Account(valid_pk, domain = domain, data.table = FALSE,
                         limit = 56,
                         order = "desc")
  expect_equal(as.character(a3[['_links']][['self']]),
               target_url)
})

test_that("Error handling for bad public key.", {
  # Neither the testnet or public networks return an error for a bad public key.
  # This seems like a bug. Creating a placeholder test which will fail when the bug is fixed.
  a4 = getOffers_Account(invalid_pk, domain = domain, data.table = FALSE)
  expect_true(exists("_links", a4))
})
