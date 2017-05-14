MoneyRails.configure do |config|
  config.default_bank = Money::Bank::VariableExchange.new(ExchangeRate)
end
