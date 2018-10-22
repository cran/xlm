context("Unit tests for the Ledgers object.")

old_scipen = options()$scipen
options(scipen = 100)

valid_sequence = "3"
invalid_sequence = -3

ledger3 = Ledger$new(valid_sequence, domain)

test_that("Ledger is an R6Class object.", {
  expect_true(is.R6Class(Ledger))
  expect_true(Ledger$class)
  expect_equal(Ledger$classname, "Ledger")
  expect_named(Ledger$public_fields,
               c("sequence", "hash", "transaction_count", "operation_count", "closed_at",
                 "total_coins", "response"))
})

test_that("Ledger class can be initialised.", {
  expect_true(any(class(ledger3) == "Ledger"))
  expect_equal(ledger3$sequence, valid_sequence)
  expect_type(ledger3$response, "list")
})

test_that("The method to retrieve effects, transactions etc can be called successfully by the Ledger object.", {

  n = 150
  ord = 'asc'

  test_sequence = "3"

  ledger10561820 = Ledger$new(test_sequence, domain = domain)

  # effects
  effects = ledger10561820$effects(data.table = FALSE, limit=n, domain = domain)
  expect_true(exists("records", effects[['_embedded']]))
  expect_equal(as.character(effects[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/ledgers/%s/effects?cursor=&limit=%d&order=%s",
                       test_sequence, n, ord))

  # payments
  payments = ledger10561820$payments(data.table = FALSE, limit=n, domain = domain)
  expect_true(exists("records", payments[['_embedded']]))
  expect_equal(as.character(payments[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/ledgers/%s/payments?cursor=&limit=%d&order=%s",
                       test_sequence, n, ord))

})

test_that("Bad address fails on initialisation.", {
  wrong_number_error_msg = "^The sequence number must be"
  strng_literal_message = "Pass a string literal"

  expect_error(
    expect_warning(
      Ledger$new(invalid_sequence), string_literal_message),
    wrong_number_error_msg
    )
})

options(scipen = old_scipen)

