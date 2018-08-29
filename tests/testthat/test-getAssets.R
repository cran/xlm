context("Get the assets issued on the Stellar network...")


n = 25

id = "000001"

test_that("The first 20 assets from the network can be pulled.", {
  assets = expect_warning(getAssets(limit = n, domain=domain))$main_table
  expect_true(is.data.table(assets))
  expect_equal(nrow(assets), n)
  expect_equal(assets$asset_code[1], id)
  expect_named(assets, c("asset_type","asset_code","asset_issuer", "paging_token",
                    "amount", "num_accounts"))
})

test_that("Check that the correct endpoint was called and that a data.table can be created.", {

  target_url = sprintf(
    "https://horizon-testnet.stellar.org/assets?asset_code=&asset_issuer=&cursor=&limit=%s&order=asc",
    n)

  assets = getAssets(n, domain=domain, data.table = FALSE)
  expect_named(assets, c("_links", "_embedded"))
  expect_true(exists("records", assets[['_embedded']]))
  expect_equal(target_url, as.character(assets[['_links']][['self']]))
  expect_length(assets[['_embedded']][['records']], n)

})


