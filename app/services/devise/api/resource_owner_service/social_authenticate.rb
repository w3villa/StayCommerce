# frozen_string_literal: true

module Devise
  module Api
    module ResourceOwnerService
      class SocialAuthenticate < Devise::Api::BaseService
        option :params, type: Types::Hash
        option :resource_class, type: Types::Class

        def call
          resource = resource_class.find_for_authentication(email: params["email"])
          return Failure(error: :invalid_email, record: nil) if resource.blank?
          Success(resource)
        end

        private

        def authenticate!(resource)
          resource.valid_for_authentication? do
            resource.valid_password?(params[:password])
          end && resource.active_for_authentication?
        end
      end
    end
  end
end
