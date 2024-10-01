module Stay
  class Country < ApplicationRecord
    has_many :addresses
    has_many :states, class_name: 'Stay::State', dependent: :destroy

    def self.ransackable_attributes(auth_object = nil)
      ["name"]
    end

    def self.default(store = nil)
      store ||= Stay::Store.default
      country_id = store.default_country_id
      default = find_by(id: country_id) if country_id.present?
      default || find_by(iso: 'US') || first
    end

    def default?(store = nil)
      store ||= Stay::Store.default
      self == store.default_country
    end
  end
end
