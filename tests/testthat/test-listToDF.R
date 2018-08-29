context("Testing the list to table converter.")

test_address = "GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC"
test_hash = "b957fd83d5377402ee995d1c3ff4834357f48cbe9a6d42477baad52f1351c155"

load("../data/test_transactions.rda")
load("../data/test_operations.rda")
load("../data/test_effects.rda")
load("../data/test_payments.rda")
load("../data/test_ledgers.rda")

test_that("Sample transactions object can be parsed to data.table(s).",{

  dfs = expect_warning(listToDF(test_txns), "The data returned contained nested structures.")
  expect_length(dfs, 2)
  expect_named(dfs, c("main_table", "lookup_table"))
  expect_true(is.data.table(dfs$main_table))
  expect_true(is.data.table(dfs$lookup_table))

  expect_equal(nrow(dfs$main_table), 20)
  expect_true(all(c("id", "hash", "ledger", "signatures", "memo") %in% names(dfs$main_table)))
  expect_equal(dfs$main_table[1]$memo, "hello world")

  expect_equal(nrow(dfs$lookup_table), 3)
  expect_named(dfs$lookup_table, c("id", "field", "value"))
})


test_that("Sample ledgers can be parsed to data.table(s).",{

  df = listToDF(test_ledgers)
  expect_true(is.data.table(df))

  expect_equal(nrow(df), 10)
  expect_true(all(c("id", "hash", "sequence", "transaction_count", "fee_pool") %in% names(df)))
  expect_equal(df[1]$sequence, 1)

})

test_that("Sample effects can be parsed to data.table(s).",{

  df = listToDF(test_effects)
  expect_true(is.data.table(df))

  expect_equal(nrow(df), 10)
  expect_true(all(c("id", "type", "amount", "account", "paging_token") %in% names(df)))
  expect_equal(df[1]$id, "0000000012884905985-0000000001")

})

test_that("Sample operations can be parsed to data.table(s).",{

  df = listToDF(test_operations)
  expect_true(is.data.table(df))

  expect_equal(nrow(df), 10)
  expect_true(all(c("id", "type", "starting_balance", "funder", "from", "to") %in% names(df)))
  expect_equal(df[1]$id, "12884905985")

})

test_that("Sample payments can be parsed to data.table(s).",{

  df = listToDF(test_payments)
  expect_true(is.data.table(df))

  expect_equal(nrow(df), 10)
  expect_true(all(c("id", "type", "type_i", "funder", "from", "to", "amount") %in% names(df)))
  expect_equal(df[1]$created_at, "2015-09-30T17:15:54Z")

})
