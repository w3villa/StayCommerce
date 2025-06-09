class CreditCardSerializer < ActiveModel::Serializer
  attributes :id, :month, :year, :cc_number, :cc_type, :name, :payment_method_token, :card_token
end
