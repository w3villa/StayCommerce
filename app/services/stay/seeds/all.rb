module Stay
  module Seeds
    class All
      def self.call
          # GEO
          Countries.call
          States.call
          # Zones.call

          # user roles
          Roles.call

          # additional data
          # DefaultReimbursementTypes.call
          # ShippingCategories.call
          # StoreCreditCategories.call

          # # store & stock location
          # Stores.call
          # StockLocations.call

          # # add store resources
          # PaymentMethods.call
      end
    end
  end
end
