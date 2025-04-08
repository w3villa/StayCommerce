class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :email, :first_name, :full_name, :last_name,  :phone, :gender, :is_user, :is_host, :date_of_birth,
               :image, :whatsapp_notification, :sms_notification, :image_file_name,

  def full_name
    object.full_name
  end

  def is_user
    object.stay_user?
  end

  def is_host
    object.stay_host?
  end

  def date_of_birth
    object.date_of_birth && object.date_of_birth.strftime("%Y-%m-%d")
  end

  def image
    object.profile_image.url || nil
  end

  def whatsapp_notification
    object&.preferences.present? ? object&.preferences["whatsapp_notification"]: false
  end

  def sms_notification
    object&.preferences.present? ? object&.preferences["sms_notification"]: false
  end

  def image_file_name
    object.profile_image&.filename&.to_s || nil
  end
end
