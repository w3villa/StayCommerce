module Stay
  class Configuration
    attr_accessor :storefront_taxons_path

    def initialize
      @storefront_taxons_path = 't'  # default value
    end
  end
end
