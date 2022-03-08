require "csv"
require "exchange_rates_nbp"
require "json"
require "enumerator"

file = File.open("data.csv").read

# stocks:

stocks_raw_data_indices = file
  .enum_for(:scan, /Trades,Header/)
  .map { Regexp.last_match.begin(0) }
stocks_csv_data = CSV.parse(
  file[stocks_raw_data_indices[0]..stocks_raw_data_indices[1] - 1],
  :headers => true
)
stocks_data = {}

total_sell = 0
total_buy = 0

stocks_csv_data.each do |stock|
  next unless stock["Header"] == "Data"

  stocks_data[stock["Symbol"]] ||= {
    quantity: 0,
    buy_price_pln: 0,
    sold_price_pln: 0,
    income: 0
  }

  usd_rate = ExchangeRatesNBP.exchange_rate(Date.parse(stock["Date/Time"]) - 1, "USD")

  if stock["Quantity"].to_i.negative? # selling
    stocks_data[stock["Symbol"]][:sold_price_pln] = stock["Proceeds"].to_f.abs * usd_rate
    stocks_data[stock["Symbol"]][:income] += (
      stocks_data[stock["Symbol"]][:sold_price_pln] - stocks_data[stock["Symbol"]][:buy_price_pln]
    )
    total_sell += stocks_data[stock["Symbol"]][:sold_price_pln]
    total_buy += stocks_data[stock["Symbol"]][:buy_price_pln]
  else # buying
    stocks_data[stock["Symbol"]][:buy_price_pln] = stock["Proceeds"].to_f.abs * usd_rate
  end
end

# puts JSON.pretty_generate(stocks_data)
puts "Total to pay for stocks (in PLN) -- Income earned abroad (item 32 in PIT-ZG): #{stocks_data.sum { |k,v| stocks_data[k][:income] * 0.19 }}"

puts "Income earned abroad (item 32 in PIT-ZG): #{stocks_data.sum { |k,v| stocks_data[k][:income] }}"
puts "Revenue (item 22 in PIT-38): #{total_sell}"
puts "Tax deductible expenses (item 23 in PIT-38): #{total_buy}"

# dividends:

dividends_csv_data = CSV.parse(
  file[file.index("Dividends,Header")..file.index("Dividends,Data,Total") - 1],
  :headers => true
)
dividends_income_total_pln = 0
dividends_csv_data.each do |div|
  next unless div["Header"] == "Data"
  usd_rate = ExchangeRatesNBP.exchange_rate(Date.parse(div["Date"]) - 1, "USD")
  dividends_income_total_pln += div["Amount"].to_f.abs * usd_rate
end

withholding_dividends_csv_data = CSV.parse(
  file[file.index("Withholding Tax,Header")..file.index("Withholding Tax,Data,Total") - 1],
  :headers => true
)
withholding_dividends_total_pln = 0
withholding_dividends_csv_data.each do |div|
  next unless div["Header"] == "Data"
  usd_rate = ExchangeRatesNBP.exchange_rate(Date.parse(div["Date"]) - 1, "USD")
  withholding_dividends_total_pln += div["Amount"].to_f.abs * usd_rate
end

puts "Total to pay for dividends (in PLN): #{dividends_income_total_pln * 0.19 - withholding_dividends_total_pln }"

puts "Lump-sum tax calculated on revenue referred to in Article 30a(1)(1) - (5) of the Act (item 45 in PIT-38): #{dividends_income_total_pln * 0.19}"
puts "Tax paid abroad, referred to in Article 30a(9) of the Act (item 46 in PIT-38): #{withholding_dividends_total_pln}"
