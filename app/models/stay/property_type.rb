module Stay
  class PropertyType < ApplicationRecord
    validates :name,  presence: true, uniqueness: { case_sensitive: false }, 
    format: { without: /_/, message: "must not contain underscores" }

    has_many :properties, class_name: "Stay::Property", dependent: :nullify
    def self.ransackable_attributes(auth_object = nil)
      %w[id name created_at updated_at]
    end

    def self.ransackable_associations(auth_object = nil)
      []
    end
  end
end
