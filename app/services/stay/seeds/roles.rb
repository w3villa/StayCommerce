module Stay
  module Seeds
    class Roles
      def self.call
        Stay::Role.where(name: 'admin').first_or_create!
      end
    end
  end
end