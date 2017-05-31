module PricesHelper
  def prices_by_country(games: [], countries:, currency: nil)
    prices = games.flat_map(&:prices)
    cache = prices.each_with_object({}) do |price, result|
      result[price.country] = price.value.exchange_to(currency || 'USD')
    end
    min, max = cache.values.minmax

    countries.each do |country|
      price = prices.detect { |p| p.country == country }
      title = "\"#{games.first.title}\" price in #{ISO3166::Country[country].translation('en')}"
      if price
        options = {
          class: (min == cache[country] && 'table-success') || (max == cache[country] && 'table-danger'),
          title: title,
        }
        yield(price.value.exchange_to(currency || price.currency).format, options)
      else
        yield('N/A', { class: 'text-muted', title: title })
      end
    end
  end
end
