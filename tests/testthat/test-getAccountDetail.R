context("Unit tests for the accounts endpoint, where details about specific accounts are returned only.")

valid_pk = "GA2HGBJIJKI6O4XEM7CZWY5PS6GKSXL6D34ERAJYQSPYA6X6AI7HYW36"
invalid_pk = "qwerty"

test_that("Valid account returns a 200 response with the expected fields.", {
  a1 = getAccountDetail(valid_pk, domain = domain)
  expect_equal(.requestBuilder("accounts", id = valid_pk, domain = domain),
               as.character(a1[['_links']][['self']]))
  expect_equal(valid_pk, a1[['account_id']])
  expected_names = c("id", "sequence", "data", "signers", "_links", "balances")
  for(n in expected_names){
    expect_true(exists(n, a1))
  }
})

test_that("Invalid accounts are handled appropriately.", {
  expect_error(getAccountDetail(invalid_pk, domain = domain), "The resource at the url requested was not found")
})

