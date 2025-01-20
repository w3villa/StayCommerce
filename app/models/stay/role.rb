module Stay
  class Role < ApplicationRecord
    has_many :role_users, class_name: "Stay::RoleUser", dependent: :destroy
    has_many :users, through: :role_users, class_name: "Stay::User"
    validates :name, presence: true, uniqueness: { case_sensitive: false }

    USER = "student".freeze
    ADMIN = "admin".freeze
    HOST = "host".freeze
  end
end
