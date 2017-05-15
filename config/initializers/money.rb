MoneyRails.configure do |config|
  REDIS_URL = ENV.fetch('REDIS_URL', 'redis://localhost:6379')
  config.default_bank = Money::Bank::VariableExchange.new(ExchangeRate.new(url: REDIS_URL))
end
