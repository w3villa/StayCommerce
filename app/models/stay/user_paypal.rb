module Stay
  class UserPaypal < ApplicationRecord
    belongs_to :user, class_name: "Stay::User"
  end
end
