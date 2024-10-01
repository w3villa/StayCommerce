module Stay
  module Seeds
    class CancellationPolicy
      def self.call
        [ "strict", "moderate", "flexible" ].each do |policy|
          Stay::CancellationPolicy.find_or_create_by!(name: policy, description: "")
        end
      end
    end
  end
end
