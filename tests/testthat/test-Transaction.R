context("Unit tests for the Transaction object.")

old_scipen = options()$scipen
options(scipen = 100)

valid_hash = "afbe6f687c85d1f34ea18b73629be006518a2a3f5891760086340b4f1e834ccb"
invalid_hash = 12345677890000



t1 = Transaction$new(valid_hash, "testnet")

test_that("Transaction is an R6Class object.", {
  expect_true(is.R6Class(Transaction))
  expect_true(Transaction$class)
  expect_equal(Transaction$classname, "Transaction")
  expect_named(Transaction$public_fields,
               c("ledger", "hash", "source_account", "created_at", "fee_paid", "response"))
})

test_that("Transaction class can be initialised.", {
  expect_false(is.R6Class(t1))
  expect_true(any(class(t1) == "Transaction"))
  expect_equal(t1$hash, valid_hash)
  expect_type(t1$response, "list")
})

test_that("The method to retrieve effects, transactions etc can be called successfully by the Transaction object.", {

  n = 25
  ord = 'asc'

  test_hash = "9a9fec714911b74510fff65cc41aac2c466b3db1b548fa82323ba3516240be7a"

  t2 = Transaction$new(test_hash, domain = domain)

  # ops
  operations = t2$operations(data.table = FALSE, limit=n, domain = domain)
  operations_df = listToDF(operations)

  expect_true(exists("records", operations[['_embedded']]))
  expect_equal(t2$response$operation_count, length(operations[['_embedded']][['records']]))
  expect_equal(t2$response$operation_count, nrow(operations_df))

  expect_equal(as.character(operations[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/transactions/%s/operations?cursor=&limit=%d&order=%s",
                       test_hash, n, ord))

  # effects
  effects = t2$effects(data.table = FALSE, limit=n, domain = domain)
  expect_true(exists("records", effects[['_embedded']]))
  expect_equal(as.character(effects[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/transactions/%s/effects?cursor=&limit=%d&order=%s",
                       test_hash, n, ord))

  # payments
  payments = t2$payments(data.table = FALSE, limit=n, domain = domain)
  expect_true(exists("records", payments[['_embedded']]))
  expect_equal(as.character(payments[['_links']][['self']]),
               sprintf("https://horizon-testnet.stellar.org/transactions/%s/payments?cursor=&limit=%d&order=%s",
                       test_hash, n, ord))

})

test_that("Bad hash fails on initialisation.", {
  expect_error(Transaction$new(invalid_hash), "Resource Missing")
})

options(scipen = old_scipen)

