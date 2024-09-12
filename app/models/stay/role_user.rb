module Stay
  class RoleUser < ApplicationRecord
    belongs_to :user, class_name: 'Stay::User'
    belongs_to :role, class_name: 'Stay::Role'
  end
end
