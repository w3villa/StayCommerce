module Stay
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    include Stay::RansackableAttributes
  end
end
