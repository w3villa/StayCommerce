module Stay
  class Store < ApplicationRecord
    include TranslatableResource
    # acts_as_paranoid

    TRANSLATABLE_FIELDS = %i[meta_description meta_keywords seo_title facebook
                             twitter instagram customer_support_email description
                             address contact_phone new_order_notifications_email].freeze
    translates(*TRANSLATABLE_FIELDS)

    self::Translation.class_eval do
      acts_as_paranoid
      # deleted translation values still need to be accessible - remove deleted_at scope
      default_scope { unscope(where: :deleted_at) }
    end

    acts_as_paranoid

    has_many :bookings, class_name: 'Stay::Booking'
    has_many :line_items, through: :bookings, class_name: 'Stay::LineItem'
    has_many :payments, through: :bookings, class_name: 'Stay::Payment'
    has_many :store_properties, class_name: 'Stay::StoreProperty'
    has_many :properties, through: :store_properties, class_name: 'Stay::Property'
    has_many :rooms, through: :properties, class_name: 'Stay::Room', source: :rooms_including_master
    has_many :taxonomies, class_name: 'Stay::Taxonomy'
    has_many :taxons, through: :taxonomies, class_name: 'Stay::Taxon'

    validates :code, uniqueness: { case_sensitive: false, conditions: -> { with_deleted }}

    default_scope { order(created_at: :asc) }

    before_save :ensure_default_exists_and_is_unique
    before_save :ensure_supported_currencies, :ensure_supported_locales
    before_destroy :pass_default_flag_to_other_store

    scope :by_url, ->(url) { where('url like ?', "%#{url}%") }

    after_commit :clear_cache

    alias_attribute :contact_email, :customer_support_email

    def self.default
      Rails.cache.fetch('default_store') do
        if where(default: true).any?
          where(default: true).first
        else
          new(default: true)
        end
      end
    end

    def self.available_locales
      Rails.cache.fetch('stores_available_locales') do
        Stay::Store.all.map(&:supported_locales_list).flatten.uniq
      end
    end

    def unique_name
      @unique_name ||= "#{name} (#{code})"
    end

    def formatted_url
      return if url.blank?

      @formatted_url ||= if url.match(/http:\/\/|https:\/\//)
                           url
                         else
                           Rails.env.development? || Rails.env.test? ? "http://#{url}" : "https://#{url}"
                         end
    end

    def supported_locales_list
      @supported_locales_list ||= (read_attribute(:supported_locales).to_s.split(',') << default_locale).compact.uniq.sort
    end

    def supported_currencies_list
      @supported_currencies_list ||= (read_attribute(:supported_currencies).to_s.split(',') << default_currency).sort.map(&:to_s).map do |code|
        ::Money::Currency.find(code.strip)
      end.uniq.compact
    end

    def can_be_deleted?
      self.class.where.not(id: id).any?
    end

    def seo_meta_description
      if meta_description.present?
        meta_description
      elsif seo_title.present?
        seo_title
      else
        name
      end
    end

  private

    def ensure_supported_locales
      return unless attributes.keys.include?('supported_locales')
      return if supported_locales.present?
      return if default_locale.blank?

      self.supported_locales = default_locale
    end

    def ensure_default_exists_and_is_unique
      if default
        Store.where.not(id: id).update_all(default: false)
      elsif Store.where(default: true).count.zero?
        self.default = true
      end
    end

    def ensure_supported_currencies
      return unless attributes.keys.include?('supported_currencies')
      return if supported_currencies.present?
      return if default_currency.blank?

      self.supported_currencies = default_currency
    end

    def validate_not_last
      unless can_be_deleted?
        errors.add(:base, :cannot_destroy_only_store)
        throw(:abort)
      end
    end

     def pass_default_flag_to_other_store
      if default? && can_be_deleted?
        self.class.where.not(id: id).first.update!(default: true)
        self.default = false
      end
    end

    def clear_cache
      Rails.cache.delete('default_store')
      Rails.cache.delete('stores_available_locales')
    end
  end
end
