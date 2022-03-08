## Polish tax calculator for Interactive Brokers
### How to use

1. In IB, go to Reports->Default Statements->Activity (https://www.interactivebrokers.co.uk/AccountManagement/AmAuthentication?action=Statements)
2. Generate annual CSV report for e.g. 2021
3. Put it in the folder with this script as `data.csv`
4. Run `bundle` to install required libs
5. Run `ruby calc.rb`

### Notes

! This script is just PoC and works only in very basic cases when you buy N amount of stocks and then you sell the same N amount. So keep this info in mind and use it on your risk. Better to check all numbers manually afterwards

```
"Your income" ->
"edit income (revenue, expenses, tax)" ->

"Other revenue, including revenue earned abroad and revenue from sale of virtual currencies – Article 30B(1A) of the Act" ->
"Revenue (item 22 in PIT-38)" -- "full buy price" ->
"Tax deductible expenses (item 23 in PIT-38)" -- "full sell price" ->
"Revenue earned abroad" -- "check" -->
"Income type" -- "other revenue" -->
"Country" -- "amerika" -->
"Income earned abroad (item 32 in PIT-ZG)" -- "full income" -->
"Show tax on this income paid abroad (item 33 in PIT-ZG)" -- "0"

"Lump-sum tax on revenue (income) earned abroad" -->
"Lump-sum tax calculated on revenue referred to in Article 30a(1)(1) - (5) of the Act (item 45 in PIT-38)" -- "dividends_income_total_pln * 0.19" -->
"Tax paid abroad, referred to in Article 30a(9) of the Act (item 46 in PIT-38)" -- "withholding_dividends_total_pln"
```
