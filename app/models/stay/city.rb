module Stay
  class City < ApplicationRecord   
    belongs_to :state, class_name: 'Stay::State', foreign_key: 'state_id'
  end
end
