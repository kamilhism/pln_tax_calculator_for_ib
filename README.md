## Polish tax calculator for Interactive Brokers
### How to use

1. In IB, go to Reports->Default Statements->Activity (https://www.interactivebrokers.co.uk/AccountManagement/AmAuthentication?action=Statements)
2. Generate annual CSV report for e.g. 2021
3. Put it in the folder with this script as `data.csv`
4. Run `bundle` to install required libs
5. Run `ruby calc.rb`

### Notes

! This script is just PoC and works only in very basic cases when you buy N amount of stocks and then you sell the same N amount. So keep this info in mind and use it on your risk. Better to check all numbers manually afterwards
