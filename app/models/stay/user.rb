module Stay
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable,:api

    has_many :role_users, class_name: 'Stay::RoleUser', foreign_key: :user_id, dependent: :destroy
    has_many :stay_roles, through: :role_users, class_name: 'Stay::Role', source: :role
    has_many :bookings
    has_many :reviews
    has_many :properties
    has_many :sent_chats, class_name: 'Stay::Chat', foreign_key: :sender_id, dependent: :destroy
    has_many :received_chats, class_name: 'Stay::Chat', foreign_key: :receiver_id, dependent: :destroy

    users_table_name = User.table_name
    roles_table_name = Role.table_name

    scope :admin, -> { includes(:stay_roles).where("#{roles_table_name}.name" => "admin") }

    def has_stay_role?(role_name)
      stay_roles.exists?(name: role_name)
    end

    def stay_admin?
      has_stay_role?('admin')
    end
  end
end
