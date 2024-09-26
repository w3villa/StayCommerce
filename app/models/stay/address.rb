module Stay
  class Address < ApplicationRecord
    belongs_to :state, class_name: 'Stay::State'
    belongs_to :country, class_name: 'Stay::Country'
    has_many :properties, class_name: 'Stay::Property'

    belongs_to :user, class_name: 'Stay::Address', optional: true
    # geocoded_by :full_address
    # after_validation :geocode, if: ->(obj){ obj.address1.present? && obj.zipcode.present? }

    
    NO_ZIPCODE_ISO_CODES ||= [
      'AO', 'AG', 'AW', 'BS', 'BZ', 'BJ', 'BM', 'BO', 'BW', 'BF', 'BI', 'CM', 'CF', 'KM', 'CG',
      'CD', 'CK', 'CUW', 'CI', 'DJ', 'DM', 'GQ', 'ER', 'FJ', 'TF', 'GAB', 'GM', 'GH', 'GD', 'GN',
      'GY', 'HK', 'IE', 'KI', 'KP', 'LY', 'MO', 'MW', 'ML', 'MR', 'NR', 'AN', 'NU', 'KP', 'PA',
      'QA', 'RW', 'KN', 'LC', 'ST', 'SC', 'SL', 'SB', 'SO', 'SR', 'SY', 'TZ', 'TL', 'TK', 'TG',
      'TO', 'TV', 'UG', 'AE', 'VU', 'YE', 'ZW'
    ].freeze

    # The required states listed below match those used by PayPal and Shopify.
    STATES_REQUIRED = [
      'AU', 'AE', 'BR', 'CA', 'CN', 'ES', 'HK', 'IE', 'IN',
      'IT', 'MY', 'MX', 'NZ', 'PT', 'RO', 'TH', 'US', 'ZA'
    ].freeze
    
    def self.ransackable_associations(auth_object = nil)
      [ "properties", "user"]
    end

    def self.ransackable_attributes(auth_object = nil)
      ["address1", "address2", "city", "state", "country", "zipcode"]
    end

    def full_address
      [address1, address2, city.try(:name), state.try(:name), country.try(:name), zipcode].compact.join(', ')
    end
  end
end