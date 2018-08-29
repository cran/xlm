context("Test the distribution stats.")

test_that("200 response is returned.", {
  d = distribution()
  expect_type(d, "list")
  expect_named(d, c("updatedAt", "totalCoins", "availableCoins", "distributedCoins",
                    "programs"))
})

