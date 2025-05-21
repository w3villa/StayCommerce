class CreditCardSerializer < ActiveModel::Serializer
  attributes :id, :month, :year, :cc_number, :cc_type, :name, :user
  belongs_to :user
  # def user
  #   UserSerializer.new(object.user)
  # end
end
