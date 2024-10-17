class PropertyFeatureSerializer < ActiveModel::Serializer
  attributes :id , :feature_id
  has_many :properties, serializer: PropertySerializer

end