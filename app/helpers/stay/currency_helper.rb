module Stay
  module CurrencyHelper

    def current_currency
      Rails.application.config.default_currency || 'USD'
    end

    def currency_symbol
      Rails.application.config.currency_symbols[current_currency] || ''
    end
  end
end
