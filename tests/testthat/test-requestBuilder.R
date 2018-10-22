context("Unit tests for request builder - a URL constructor.")

pk = "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ"
hash = "d951a576e31a174bc438de0cf08ccf654f7045d56e0f34bd66ee9bf58dccd44a"
key = "user-id"
ledger = 12345
op = 123456789

test_that("Public network and test network urls are constructed properly.", {

  error_msg = "It must be either 'testnet' or 'public'"

  expect_error(.requestBuilder("accounts", id = pk, domain = ""), error_msg)
  expect_equal(.requestBuilder("accounts", id = pk, domain = domain),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s", pk))
  expect_equal(.requestBuilder("accounts", id = pk, domain = "public"),
               sprintf("https://horizon.stellar.org/accounts/%s", pk))

})

test_that("Accounts - endpoint requests are constructed correctly.", {

  expect_error(.requestBuilder("accounts"), "an account id must be specified")
  expect_equal(.requestBuilder("accounts", id = pk, domain = domain),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s", pk))
  expect_equal(.requestBuilder("accounts", resource = "data", id = pk, domain = domain, key = key),
               sprintf("https://horizon-testnet.stellar.org/accounts/%s/data/%s", pk, key))

  resources = c("effects", "offers", "operations", "payments", "transactions")
  for (resource in resources){
    expect_equal(.requestBuilder("accounts", resource = resource, id = pk, domain = domain),
                 sprintf("https://horizon-testnet.stellar.org/accounts/%s/%s", pk, resource))
  }

})

test_that("Accounts - 'User-defined' data keys are encoded to ASCII characters in the final URL where required.", {
  naughty_key = "Hello Günter"
  expect_equal(.requestBuilder("accounts", resource = "data", id = pk, domain = domain, key = naughty_key),
               "https://horizon-testnet.stellar.org/accounts/GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ/data/Hello%20G%C3%BCnter")
})

test_that("Transactions - endpoint requests are constructed correctly.", {

  expect_equal(.requestBuilder("transactions", domain = domain),
               "https://horizon-testnet.stellar.org/transactions")
  expect_equal(.requestBuilder("transactions", id = hash, domain = domain),
               sprintf("https://horizon-testnet.stellar.org/transactions/%s", hash))
  resources = c("effects", "operations", "payments")
  for (resource in resources){
    expect_equal(.requestBuilder("transactions", resource = resource, id = hash, domain = domain),
                 sprintf("https://horizon-testnet.stellar.org/transactions/%s/%s", hash, resource))
  }
})

test_that("Operations - endpoint requests are constructed correctly.", {
  expect_equal(.requestBuilder("operations", domain = domain),
               "https://horizon-testnet.stellar.org/operations")
  expect_equal(.requestBuilder("operations", id = op, domain = domain),
               sprintf("https://horizon-testnet.stellar.org/operations/%s", op))
})

test_that("Ledgers - endpoint requests are constructed correctly.", {
  expect_equal(.requestBuilder("ledgers", domain = domain),
               "https://horizon-testnet.stellar.org/ledgers")
  expect_equal(.requestBuilder("ledgers", id = ledger, domain = domain),
               sprintf("https://horizon-testnet.stellar.org/ledgers/%s", ledger))
  resources = c("effects", "operations", "payments", "transactions")
  for(resource in resources){
    expect_equal(.requestBuilder("ledgers", resource = resource, id = ledger, domain = domain),
                 sprintf("https://horizon-testnet.stellar.org/ledgers/%s/%s", ledger, resource))
  }
})

test_that("The simpler URL constructs work correctly.", {
  endpoints = c("assets", "effects", "trade_aggregations",
                "payments", "trades", "paths", "order_book")
  for(endpoint in endpoints){
    expect_equal(.requestBuilder(endpoint, domain = domain),
                 sprintf("https://horizon-testnet.stellar.org/%s", endpoint))
  }
})

test_that("Appropriate error handling is performed.", {
  expect_error(.requestBuilder("bad_endpoint"), "^Unknown endpoint specified\\.")
  expect_error(.requestBuilder(), "^The endpoint parameter has been supplied incorrectly.$")
})
