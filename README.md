# xlm - an R library for Stellar
![](man/figures/logo.png "Stellar Lumens logo")


[![CRAN
Status](https://www.r-pkg.org/badges/version/xlm)](https://cran.r-project.org/package=xlm)

## Disclaimer

This is not a project maintained by or officially endorsed by the [Stellar Development Foundation.](https://www.stellar.org/)

## Updates

- 14-10-2018 - A number of failing tests have been temporarily removed due to the test network of Horizon being reset. Hard-coded addresses no-longer exist on the network with the transactions associated with them. A boot-strapping script has been implemented.

## Install

When it is available to pull directly from CRAN, you can do so by running the following:

```r
install.packages("xlm")
```

To install the development version, install the `devtools` library and run the following:

```r
devtools::install_github("froocpu/xlm") # install.packages("devtools")
```

## What is this?

This library interfaces with Stellar's Horizon API and opens up the Stellar network to statisticians, business analysts and developers who are interested in:

- Performing their own analysis of the data on the public ledger.
- Building general purpose applications and web applications in R, or R-based tools like R Shiny.

## Contributing

Please use the [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) when contributing:

- Fork the project (https://github.com/[your-git-username]/xlm/fork)
- Create a feature branch `git checkout -b descriptive-feature-branch-name`
- Commit your changes `git commit -am "Some cool changes."`
- Push your branch `git push origin descriptive-feature-branch-name` and then create a new pull request.

## Tutorial

### Getting help

To get any help on a function, in the console, run `?` followed by the name of the function. For example:

```?getAccountDetail```

### Test and public networks

All the functionality in this library can be utilised on both the test and public Horizon networks. All testing by default uses the *test network* and this can be changed in `tests/testthat/helper-config.R`. The main R functions, however, will default to the **public network**. You can change this by changing the `domain` parameter for each function:

```r
t100 = getTransactions(100, domain = "testnet")
```

### Friendbot

You can call the Friendbot service to fund an account on the test network with 10000 lumens:

```r
my_test_account = "GAKYVLEN4MFPQ2R5Y4BA5RSJ7U5R2HGOK3VJ5PEUTLOHKTCBGCJZSHOS"

friendbot(my_test_account)

test_account = Account$new(my_test_account, domain="testnet")
test_account$get_xlm_balance()
# [1] 10000
```

### Accounts

#### Account class

As you may have noticed earlier, the easiest way to pull data about an account and work with it is to initialise an `Account` object using a known public key like so: 

```r
binance = Account$new("GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC")
```
If the request is successful, you will have an Account object containing data and useful methods to query the account. For example, any of the following calls should give you useful information about the account:

```r
binance$get_xlm_balance()
# 146420875.804257

binance$sequence
# "64034663848820891"

binance$signers
# [[1]]
# [[1]]$`public_key`
# [1] "GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC"
#
# [[1]]$weight
# [1] 1
#
# [[1]]$key
# [1] "GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC"
#
# [[1]]$type
# [1] "ed25519_public_key"

```

`Account` also has methods associated that will further query the network to get extra information like operations, effects, payments, transactions and offers. These are not included when the object is initialised. Use the `Account$operations()` to return a data.table containing the operations associated with that particular account:

```r
df = binance$operations()
names(df)

# [1] "id"               "paging_token"     "source_account"   "type"             "type_i"           "created_at"      
# [7] "transaction_hash" "starting_balance" "funder"           "account"          "asset_type"       "from"            
# [13] "to"
```

#### Refreshing the data

Accounts can change over time, whether it's the number of transactions associated with them or the data attached to the account. You can call the `refresh_data()` method to reinstate the account with the latest data:

```r
# Original amount.
binance_get_xlm_balance()
# [1] 145783525.755663

# Refresh the object.
binance$refresh_data()

# New balance.
binance$get_xlm_balance()
# [1] 145564082.251633
```

For more information about the `Account` object, run `?Account`

#### Account functions

You can also work the original response object, which is included as a list.

```r
binance$response$inflation_destination
# "GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC"
```

Or if you would rather not work with the Account class, you can use `getAccountDetail()` or similar function calls to work with the raw list object instead:

```r
a1 = getAccountDetail("GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC")
a1e = getEffects_Account("GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC", limit = 100)
```

### Ledgers

#### Ledger class

Similarly, ledgers have their own class object called `Ledger` which can be initialised and interrogated like so:

```r
genesis <- Ledger$new("1") # ledgers should be entered as character strings as R does not handle large numbers well.

genesis$total_coins
# [1] "100000000000.0000000"

genesis$hash
# [1] "39c2a3cd4141b2853e70d84601faa44744660334b48f3228e0309342e3f4eb48"

genesis$response$base_fee_in_stroops
# [1] 100
```

Ledgers have methods for getting transactions, effects, operations and payments:

```r
l3 = Ledger$new("3")
l3_ops = l3$operations()

nrow(l3_ops)
# [1] 3

names(l3_ops)
# [1] "id"                "paging_token"      "source_account"    "type"             
# [5] "type_i"            "created_at"        "transaction_hash"  "starting_balance" 
# [9] "funder"            "account"           "asset_type"        "from"             
# [13] "to"                "amount"            "master_key_weight"
```

#### Ledger functions

Alternatively, other functions exist for pulling this data without working with R6 classes:

```r
l = "3""
l3 = getLedgerDetail(l)
l3$hash
# [1] "ec168d452542589dbc2d0eb6d58c74b9bb2ccb93bba879a3b3fa73fdfa730182"

df = getTransactions_Ledger(l)
df$memo
#[1] "hello world"

```

There is also a `getLedgers()` function which allows you to retrieve a list or data.table with a summary of multiple ledgers.

```r
ledgers = getLedgers(10)
head(ledgers[,c(3,4:7)])

#           hash sequence transaction_count operation_count            closed_at
# 1: 39c2...eb48        1                 0               0 1970-01-01T00:00:00Z
# 2: fe0f...ebde        2                 0               0 2015-09-30T16:46:54Z
# 3: ec16...0182        3                 1               3 2015-09-30T17:15:54Z
# 4: 3939...7b8b        4                 0               0 2015-09-30T17:15:59Z
# 5: a6de...fd64        5                 0               0 2015-09-30T17:16:04Z
# 6: 05c1...8641        6                 0               0 2015-09-30T17:16:09Z
```

Ledgers are **final** and so they do not inherit the `refresh_data()` method.

### Transactions

#### Transaction class

Stellar transactions also has its own R6 class - `Transaction` can be initialised and queried like so:

```r
hello_world = Transaction$new("3389e9f0f1a65f19736cacf544c2e825313e8447f569233bb8db39aa607c8889")

hello_world$ledger
# [1] 3

hello_world$created_at
# [1] "2015-09-30T17:15:54Z"

hello_fx = hello_world$effects()
head(hello_fx[c(3:7)])

#         account             type type_i           created_at starting_balance
# 1: GALP...DMZTB  account_created      0 2015-09-30T17:15:54Z       20.0000000
# 2: GAAZ...CCWN7  account_debited      3 2015-09-30T17:15:54Z             <NA>
# 3: GALP...DMZTB   signer_created     10 2015-09-30T17:15:54Z             <NA>
# 4: GALP...DMZTB account_credited      2 2015-09-30T17:15:54Z             <NA>
# 5: GAAZ...CCWN7  account_debited      3 2015-09-30T17:15:54Z             <NA>
# 6: GAAZ...CCWN7   signer_removed     11 2015-09-30T17:15:54Z             <NA>
```

Methods for pulling the effects, payments and operations associated with a transaction are available.

Transactions are **final** and so they do not inherit the `refresh_data()` method.

To get more information about the `Transaction` object, run `?Transaction`.

#### Transaction functions

There are also standard R functions for transactions too:

```r
my_hash = "3389e9f0f1a65f19736cacf544c2e825313e8447f569233bb8db39aa607c8889"

t2 = getTransactionDetail(my_hash)
t2e = getEffects_Transaction(my_hash, limit=50, order="asc")
t2p = getPayments_Transaction(my_hash, domain = "testnet")

```

Retrieve up to 200 transactions a time with the following function

```r
transactions = getTransactions(200)
```

### Orderbooks

#### Orderbook class

There is an `Orderbook` R6 class that you can work with that converts bids/asks into a tabular format and allows for frequent refreshing of the state of the order book.

To check the current order books for a particular asset and issuer:

```r
orderbook = Orderbook$new(selling_asset_type = "native", # XLM markets
             buying_asset_type = "credit_alphanum4", 
             buying_asset_code = "SLT", 
             buying_asset_issuer = "GCKA6K5PCQ6PNF5RQBF7PQDJWRHO6UOGFMRLK3DYHDOI244V47XKQ4GP")

orderbook$bids
```

#### Orderbook functions

Or use the R function directly:

```r
orderbook = getOrderbook(selling_asset_type = "native",
             buying_asset_type = "credit_alphanum4", 
             buying_asset_code = "SLT", 
             buying_asset_issuer = "GCKA6K5PCQ6PNF5RQBF7PQDJWRHO6UOGFMRLK3DYHDOI244V47XKQ4GP")
```

### Assets and the SDEX

`xlm` contains functionality to interact with the Stellar Decentralised Exchange. You can get data on trades, find out what assets are issued on the exchange, and retrieve current order books. For example, to see a list of assets:

```r
assets = getAssets(50)
```

### General functions

Pull data from the `/payments`, `/operations` and `/effects` endpoints, up to 200 records at a time, in the form of a data.table or a list, with the following function calls:

```r
n = 100

operations = getOperations(n, order = "desc")
payments = getPayments(n, data.table = FALSE)
effects = getEffects(n, cursor = "now")
```

### Price functions

The `price()` function currency returns the current market price from Binance, priced in one of: 

- USDT
- BTC
- ETH
- BNB:

```r
price("USDT")

#      USDT 
# 0.2467322
```

Use `live = TRUE` to stream the current market price.

You can check the status of **lumens distributed** with the following endpoint borrowed from the [Stellar Dashboard.](https://dashboard.stellar.org/)

```r
distribution()

# $`updatedAt`
# [1] "2018-08-18T00:02:51.018Z"
# 
# $totalCoins
# [1] "104204519655.6086698"
# 
# $availableCoins
# [1] "18771754649.8634271"
# 
# $distributedCoins
# [1] "8144182475.5855983"
# 
# $programs
#        directProgram       bitcoinProgram   partnershipProgram       buildChallenge 
# "4821473705.9280414" "2037756769.6575473" "1126666667.0000096"          "158285333"
```
