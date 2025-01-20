class UserListingSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :full_name, :last_name,  :phone, :gender, :is_user, :is_host, :date_of_birth, :email_verified, :image,
  :about_me,

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
end
