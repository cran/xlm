context("Pull multiple payments.")

n = 20

test_that("The first 20 payments from the network can be pulled.", {
  payments = getPayments(n, domain=domain)
  expect_true(is.data.table(payments))
  expect_equal(nrow(payments), n)
  expect_true(all(c("id","type","type_i", "account",
                    "created_at", "funder", "asset_code", "to", "from") %in% names(payments)))

})

test_that("List object can be returned instead of a data.table.", {
  payments_ls = getPayments(n, domain = domain, data.table = FALSE)
  expect_true(exists("_embedded", payments_ls))
  expect_true(exists("records", payments_ls[['_embedded']]))
  expect_length(payments_ls[['_embedded']][['records']], n)
})


