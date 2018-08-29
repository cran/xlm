context("Test the friendbot service.")

test_that("The response returns a list.", {
  fb1 = friendbot("GAKYVLEN4MFPQ2R5Y4BA5RSJ7U5R2HGOK3VJ5PEUTLOHKTCBGCJZSHOS")
  expect_type(fb1, "list")
  expect_equal(fb1$extras$result_codes$operations, "op_already_exists")
  expect_equal(fb1$extras$result_codes$transaction, "tx_failed")
  expect_equal(fb1$status, 400)
})
