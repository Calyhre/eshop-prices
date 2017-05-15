class ExchangeRate
  def initialize(opts)
    @client = Redis.new(opts)
  end

  def add_rate(iso_from, iso_to, rate)
    @client.set key(iso_from, iso_to), rate
  end

  def get_rate(iso_from, iso_to)
    @client.get key(iso_from, iso_to)
  end

  private

  def key(a, b)
    "#{a}_TO_#{b}"
  end
end
