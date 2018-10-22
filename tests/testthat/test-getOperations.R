context("Pull multiple operations.")

n = 20

test_that("The first 20 operations from the network can be pulled.", {
  operations = getOperations(n, domain=domain)
  expect_true(is.data.table(operations))
  expect_equal(nrow(operations), n)
  expect_true(all(c("id","type","type_i", "account",
                    "created_at", "funder", "asset_code", "to", "from") %in% names(operations)))

})

test_that("List object can be returned instead of a data.table.", {
  operations_ls = getOperations(n, domain = domain, data.table = FALSE)
  expect_true(exists("_embedded", operations_ls))
  expect_true(exists("records", operations_ls[['_embedded']]))
  expect_length(operations_ls[['_embedded']][['records']], n)
})


