context("Unit tests for the underlying request utilities.")

address_good = "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ"
address_bad = "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"

url_bad = sprintf("https://horizon-testnet.stellar.org/accounts/%s", address_bad)
url_good = sprintf("https://horizon-testnet.stellar.org/accounts/%s", address_good)

test_that("Horizon request with valid URL and account succeeds.", {
  response = .getRequest(url_good)
  expect_is(response, "list")
  expect_length(response[['id']], 1)
  expect_equal(response[['id']], address_good)
  expect_equal(
    as.character(response[['_links']][['self']]),
    url_good)
})

test_that("Horizon request with bad address returns an appropriate stop message.", {
  expect_error(.getRequest(url_bad), "(\\[TITLE\\]|\\[TYPE\\]|\\[DETAIL\\])")
})

test_that("String cleaner parses as expected.", {
  target = "desc"
  expect_equal(.cleanString("DEsc "), target)
  expect_equal(.cleanString("DESC"), target)
  expect_equal(.cleanString("\tdesc"), target)
  expect_equal(.cleanString("desc\n"), target)
  expect_equal(.cleanString(target), target)
})

test_that("Common arguments to API calls have appropriate erroe handling.", {

  order_good = "asc"
  order_bad = "asec"

  limit_in_range = 100
  limit_too_low = 0
  limit_too_high = 2000
  limit_invalid = "1O0"
  limit_default = 10

  cursor_good = "now"

  error_msg = sprintf("The default of %d was used for this request", limit_default)

  test_type_and_name = function(x){
    expect_type(x, "list")
    expect_named(x, c("order", "limit", "cursor"))
  }

  cca1 = .checkCommonArgs(order=order_good, limit=limit_in_range, cursor=cursor_good)
  test_type_and_name(cca1)
  expect_equal(cca1$order, order_good)
  expect_equal(cca1$limit, limit_in_range)
  expect_equal(cca1$cursor, cursor_good)

  cca2 = expect_warning(
    .checkCommonArgs(order=order_bad, limit=limit_in_range, cursor=cursor_good))
  test_type_and_name(cca2)
  expect_equal(cca2$order, order_good)

  cca3 = expect_warning(
    .checkCommonArgs(order=order_good, limit=limit_too_low, cursor=cursor_good),
    error_msg)
  test_type_and_name(cca3)
  expect_equal(cca3$limit, limit_default)

  cca4 = expect_warning(
    .checkCommonArgs(order=order_good, limit=limit_too_high, cursor=cursor_good),
    error_msg)
  test_type_and_name(cca4)
  expect_equal(cca4$limit, limit_default)

  cca5 = expect_warning(
    .checkCommonArgs(order=order_good, limit=limit_invalid, cursor=cursor_good),
    error_msg)
  test_type_and_name(cca5)
  expect_equal(cca5$limit, limit_default)

  cca6 = .checkCommonArgs(order=order_good, limit=limit_in_range, cursor=NULL)
  test_type_and_name(cca6)
  expect_equal(cca6$cursor, "")

})

test_that("Sequence checker returns only valid character strings.", {

  wrong_number_error_msg = "^The sequence number must be"
  conversion_error_msg = "^Could not convert the sequence"
  string_literal_msg = "^Pass a string literal"

  s1 = "1"
  s2 = expect_warning(.checkSequence(1), string_literal_msg)
  s3 = "0"
  s4 = "-1"
  s5 = "abc"
  s6 = "123.456"

  expect_equal(.checkSequence(s1), s1)
  expect_equal(s2, s1)
  expect_error(.checkSequence(s3), wrong_number_error_msg)
  expect_error(.checkSequence(s4), wrong_number_error_msg)
  expect_error(.checkSequence(s5), conversion_error_msg)
  expect_error(.checkSequence(s6), wrong_number_error_msg)

})
