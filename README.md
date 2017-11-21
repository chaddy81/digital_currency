# DigitalCurrency

In order to use, run 
```
mix escript.build
```
to build the script.  From there, you can run the script with 
```
./digital_currency
```
and pass in the following options to use differeny currencies or limit the amount of returned results.
```
-c [currency] -l [limit]
```
replace [currency] with any of the following:

"AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD", "ZAR".

If you don't pass a currency, it will default to USD.

By default, the script will return the top 100.  You can limit this by replacing [limit] with an integer value.