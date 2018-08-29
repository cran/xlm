context("Pull multiple payments.")

n = 20

p1_id = "10157597659137"

test_that("The first 20 payments from the network can be pulled.", {
  payments = getPayments(n, domain=domain)
  expect_true(is.data.table(payments))
  expect_equal(nrow(payments), n)
  expect_equal(payments$id[1], p1_id)
  expect_true(all(c("id","type","type_i", "account",
                    "created_at", "funder", "asset_code", "to", "from") %in% names(payments)))

})

test_that("List object can be returned instead of a data.table.", {
  payments_ls = getPayments(n, domain = domain, data.table = FALSE)
  expect_true(exists("_embedded", payments_ls))
  expect_true(exists("records", payments_ls[['_embedded']]))
  expect_length(payments_ls[['_embedded']][['records']], n)
  expect_equal(payments_ls[['_embedded']][['records']][[1]]$id, p1_id)
})


