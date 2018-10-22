context("Unit tests for the Accounts object.")

valid_pk = test_account_1 # from helper-config
invalid_pk = "qwerty"

a1 = Account$new(valid_pk, "testnet")

test_that("Account is an R6Class object.", {
  expect_true(is.R6Class(Account))
  expect_true(Account$class)
  expect_equal(Account$classname, "Account")
  expect_named(Account$public_fields,
               c("account_id", "sequence", "balances", "signers", "data", "response", "last_refreshed", "domain"))
})

test_that("Account class can be initialised.", {
  expect_false(is.R6Class(a1))
  expect_true(any(class(a1) == "Account"))
  expect_equal(a1$account_id, valid_pk)
  expect_type(a1$response, "list")
})

test_that("Unit tests for the simpler public methods for an Account instance.", {

  # Minimum balance returns a numeric value greater than or equal to 1.
  expect_gte(a1$get_minimum_balance(), 1)

  # Balances are returned as double values.
  balance = a1$get_xlm_balance()
  expect_type(balance, "double")
  expect_gte(balance, 1)

  # Calling the refresh_data updates the private last_refreshed field.
  first_init = a1$last_refreshed
  expect_type(first_init, "double")
  a1$refresh_data()
  expect_true(a1$last_refreshed > first_init)

  # Test price integration.
  usd_value = a1$usd_value()
  expect_gt(usd_value, 0)
  expect_named(usd_value, "USDT")

})

test_that("The method to retrieve effects, transactions etc can be called successfully by the Account object.", {

  n = 10
  ord = 'asc'

  operations = a1$operations(data.table = FALSE, limit=n, domain = domain)
  expect_true(exists("records", operations[['_embedded']]))
  expect_equal(as.character(operations[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s/operations?cursor=&limit=%d&order=%s",
                       valid_pk, n, ord))

  offers = a1$offers(data.table = FALSE, limit=n, domain = domain)
  expect_true(exists("records", offers[['_embedded']]))
  expect_equal(as.character(offers[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s/offers?cursor=&limit=%d&order=%s",
                       valid_pk, n, ord))

  effects = a1$effects(data.table = FALSE, limit=n, domain = domain)
  expect_true(exists("records", effects[['_embedded']]))
  expect_equal(as.character(effects[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s/effects?cursor=&limit=%d&order=%s",
                       valid_pk, n, ord))

  transactions = a1$transactions(data.table = FALSE, limit=n, domain = domain)
  expect_true(exists("records", transactions[['_embedded']]))
  expect_equal(as.character(transactions[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s/transactions?cursor=&limit=%d&order=%s",
                       valid_pk, n, ord))

  payments = a1$payments(data.table = FALSE, limit=n, domain = domain)
  expect_true(exists("records", payments[['_embedded']]))
  expect_equal(as.character(payments[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s/payments?cursor=&limit=%d&order=%s",
                       valid_pk, n, ord))

})

