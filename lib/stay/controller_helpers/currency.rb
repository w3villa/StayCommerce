module Stay
  module ControllerHelpers
    module Currency
      extend ActiveSupport::Concern

      included do
        if defined?(helper_method)
          helper_method :supported_currencies
          helper_method :supported_currencies_for_all_stores
          helper_method :current_currency
          helper_method :supported_currency?
          helper_method :currency_param
        end
      end

      def current_currency
        @current_currency ||= if defined?(session) && session.key?(:currency) && supported_currency?(session[:currency])
                                session[:currency]
                              elsif params[:currency].present? && supported_currency?(params[:currency])
                                params[:currency]
                              elsif current_store.present?
                                current_store.default_currency
                              else
                                Stay::Store.default.default_currency
                              end&.upcase
      end

      def supported_currencies
        @supported_currencies ||= current_store&.supported_currencies_list
      end

      def supported_currencies_for_all_stores
        @supported_currencies_for_all_stores ||= begin
          (
            Stay::Store.pluck(:supported_currencies).map { |c| c&.split(',') }.flatten + Stay::Store.pluck(:default_currency)
          ).
            compact.uniq.map { |code| ::Money::Currency.find(code.strip) }
        end
      end

      def supported_currency?(currency_iso_code)
        return false if supported_currencies.nil?

        supported_currencies.map(&:iso_code).include?(currency_iso_code.upcase)
      end

      def currency_param
        return if current_currency == current_store.default_currency

        current_currency
      end
    end
  end
end
