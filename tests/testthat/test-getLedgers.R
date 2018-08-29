context("Test pulling data on multiple ledgers.")


n = 20

test_that("The first 20 ledgers from the network can be pulled.", {
  ledgers = getLedgers(n, domain=domain)

  expect_true(is.data.table(ledgers))
  expect_equal(nrow(ledgers), n)
  expect_equal(ledgers$closed_at[1], "1970-01-01T00:00:00Z")
  expect_true(all(c("id","hash","total_coins","sequence") %in% names(ledgers)))

})

test_that("List object can be returned instead of a data.table.", {
  ledgers_ls = getLedgers(n, domain = domain, data.table = FALSE)

  expect_true(exists("_embedded", ledgers_ls))
  expect_true(exists("records", ledgers_ls[['_embedded']]))
  expect_length(ledgers_ls[['_embedded']][['records']], n)

  expect_equal(ledgers_ls[['_embedded']][['records']][[1]]$sequence, 1)
})


