module Stay
  class Role < ApplicationRecord
    has_many :role_users, class_name: 'Stay::RoleUser', dependent: :destroy
    has_many :users, through: :role_users, class_name: 'Stay::User'
  end
end