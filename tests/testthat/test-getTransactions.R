context("Pull multiple transactions.")


n = 20

test_that("The first 20 transactions from the network can be pulled.", {
  transactions = expect_warning(getTransactions(limit = n, domain=domain))$main_table
  expect_true(is.data.table(transactions))
  expect_equal(nrow(transactions), n)
  expect_equal(transactions$operation_count[1], 10)
  expect_true(all(c("id","hash","ledger",
                    "created_at", "fee_paid", "source_account") %in% names(transactions)))

})

test_that("List object can be returned instead of a data.table.", {
  transactions_ls = getTransactions(n, domain = domain, data.table = FALSE)
  expect_true(exists("_embedded", transactions_ls))
  expect_true(exists("records", transactions_ls[['_embedded']]))
  expect_length(transactions_ls[['_embedded']][['records']], n)
})


