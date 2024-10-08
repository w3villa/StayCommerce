require "stay/version"
require "stay/engine"
require 'monetize'
require 'mobility'
require 'paranoia'
require 'inline_svg'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'jsbundling-rails'
require 'stay/controller_helpers/currency'
require 'stay/controller_helpers/store'
require 'bootstrap'
require 'acts_as_list'
require 'friendly_id'
require 'auto_strip_attributes'
require 'awesome_nested_set'
require 'active_storage_validations'
require 'activerecord-typedstore'

module Stay
  @@public_storage_service_name = nil 

  def self.public_storage_service_name
    if @@public_storage_service_name
      if @@public_storage_service_name.is_a?(String) || @@public_storage_service_name.is_a?(Symbol)
        @@public_storage_service_name.to_sym
      else
        raise 'Stay.public_storage_service_name MUST be a String or Symbol object.'
      end
    end
  end
end
