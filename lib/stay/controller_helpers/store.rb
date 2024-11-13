module Stay
  module ControllerHelpers
    module Store
      extend ActiveSupport::Concern

      included do
        if defined?(helper_method)
          helper_method :current_store
          helper_method :current_price_options
          helper_method :available_menus
        end
      end

      def current_store
        @current_store ||= Stay::Store.default
      end

      def store_locale
        current_store.default_locale
      end

      def ensure_current_store(object)
        return if object.nil?

        if object.has_attribute?(:store_id)
          if object.store.present? && object.store != current_store
            raise I18n.t('errors.messages.store_is_already_set')
          else
            object.store = current_store
          end
        elsif object.class.method_defined?(:stores) && object.stores.exclude?(current_store)
          object.stores << current_store
        end
      end
    end
  end
end
