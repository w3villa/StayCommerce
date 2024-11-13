module Stay
  module LocaleHelper
    def all_locales_options
      supported_locales_for_all_stores.map { |locale| locale_presentation(locale) }
    end

    def available_locales_options
      available_locales.map { |locale| locale_presentation(locale) }
    end

    def supported_locales_options
      return if current_store.nil?

      current_store.supported_locales_list.map { |locale| locale_presentation(locale) }
    end

    def supported_locales_for_all_stores
      @supported_locales_for_all_stores ||= available_locales
    end

    def available_locales
      locales_from_i18n = I18n.available_locales
      locales =
        if defined?(StayI18n)
          (StayI18n::Locale.all << :en).map(&:to_sym)
        else
          [Rails.application.config.i18n.default_locale, I18n.locale, :en]
        end

      (locales + locales_from_i18n).uniq.compact
    end

    def locale_presentation(locale)
      if I18n.exists?('stay.i18n.this_file_language', locale: locale, fallback: false)
        [locale_full_name(locale), locale.to_s]
      elsif defined?(StayI18n::Locale) && (language_name = StayI18n::Locale.local_language_name(locale))
        ["#{language_name} (#{locale})", locale.to_s]
      elsif locale.to_s == 'en'
        ['English (US)', 'en']
      else
        [locale, locale.to_s]
      end
    end

    def locale_full_name(locale)
      I18n.t('i18n.this_file_language', locale: locale)
    end

    def should_render_locale_dropdown?
      return false if current_store.nil?

      current_store.supported_locales_list.size > 1
    end

    # New methods added from the controller
    def current_locale
      @current_locale ||= if user_locale?
                            current_user.selected_locale
                          elsif params_locale?
                            params[:locale]
                          elsif config_locale?
                            config_locale
                          else
                            current_store&.default_locale || Rails.application.config.i18n.default_locale || I18n.default_locale
                          end
    end

    def supported_locales
      @supported_locales ||= current_store&.supported_locales_list
    end

    def supported_locale?(locale_code)
      return false if supported_locales.nil?

      supported_locales.include?(locale_code&.to_s)
    end

    def params_locale?
      params[:locale].present? && supported_locale?(params[:locale])
    end

    def user_locale?
      Stay::Config.use_user_locale && current_user && supported_locale?(current_user.selected_locale)
    end

    def config_locale?
      respond_to?(:config_locale, true) && config_locale.present?
    end

    def locale_param
      return if I18n.locale.to_s == current_store.default_locale || current_store.default_locale.nil?

      I18n.locale.to_s
    end

    # Optionally, you can keep this as a helper method for views
    def find_with_fallback_default_locale(&block)
      result = begin
        block.call
      rescue ActiveRecord::RecordNotFound => _e
        nil
      end

      result || Mobility.with_locale(current_store.default_locale) { block.call }
    end
  end
end
