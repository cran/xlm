
domain = "testnet"

# Prepare test accounts. --------------------------------------------------
test_account_1 = "GCPE3QUYAH3UHDRGYIOTCGRSVVUNH2LJOK375NQG4RTPLKLRHXNJE44U"
test_account_2 = "GD5I4VJHEF5IGOUHNIDZCDDMGRPSEB7ZFEAO4BOLU44OLJPT5G3LO4GP"

for (account in c(test_account_1, test_account_2)){
  httr::GET(sprintf("https://friendbot.stellar.org/?addr=%s", account))
}

