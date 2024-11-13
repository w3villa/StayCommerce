class PropertyFeatureSerializer < ActiveModel::Serializer
  attributes :id , :name, :feature_type
  # has_many :properties, serializer: PropertySerializer

end