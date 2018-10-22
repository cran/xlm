context("Pull effects data.")

n = 20

test_that("The first 20 effects from the network can be pulled.", {
  effects = getEffects(limit = n, domain=domain)
  expect_true(is.data.table(effects))
  expect_equal(nrow(effects), n)
  expect_true(all(c("id","type","type_i", "account",
                    "created_at", "weight", "amount") %in% names(effects)))

})

test_that("List object can be returned instead of a data.table.", {
  effects_ls = getEffects(n, domain = domain, data.table = FALSE)
  expect_true(exists("_embedded", effects_ls))
  expect_true(exists("records", effects_ls[['_embedded']]))
  expect_length(effects_ls[['_embedded']][['records']], n)
})


