module Stay
  class FavoriteProperty < ApplicationRecord
    belongs_to :property, class_name: "Stay::Property"
    belongs_to :user, class_name: "Stay::User"
  end
end
