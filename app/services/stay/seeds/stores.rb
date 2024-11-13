require 'paranoia'

module Stay
  module Seeds
    class Stores

      def self.call
        default_store = Stay::Store.default
        default_country_id = Stay::Country.find_by(iso: 'US')&.id

        if default_store.persisted?
          default_store.update!(default_country_id: Stay::Config[:default_country_id])
        else
          Stay::Store.new do |s|
            s.name                         = 'Stay Commerce'
            s.code                         = 'Stay'
            s.url                          = Rails.application.routes.default_url_options[:host]
            s.mail_from_address            = 'no-reply@example.com'
            s.customer_support_email       = 'support@example.com'
            s.default_currency             = 'USD'
            s.default_country_id           = default_country_id
            s.default_locale               = 'en'
            s.default                      = true
            s.seo_title                    = 'Stay Commerce Demo'
            s.meta_description             = 'This is the new Stay UX DEMO '
            s.facebook                     = 'staycommerce'
            s.twitter                      = 'staycommerce'
            s.instagram                    = 'staycommerce'
          end.save!
        end
      end
    end
  end
end
