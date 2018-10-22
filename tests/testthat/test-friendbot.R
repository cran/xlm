context("Test the friendbot service.")

test_that("The response returns a list.", {
  fb1 = friendbot(test_account_1) # from helper-config
  expect_type(fb1, "list")
  expect_equal(fb1$extras$result_codes$operations, "op_already_exists")
  expect_equal(fb1$extras$result_codes$transaction, "tx_failed")
  expect_equal(fb1$status, 400)
})
