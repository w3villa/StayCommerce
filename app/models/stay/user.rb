module Stay
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable,:api

    after_create :assign_default_role       

    has_many :role_users, class_name: 'Stay::RoleUser', dependent: :destroy
    has_many :stay_roles, through: :role_users, class_name: 'Stay::Role', source: :role
    has_many :bookings
    has_many :reviews
    has_many :properties
    has_many :sent_chats, class_name: 'Stay::Chat', foreign_key: :sender_id, dependent: :destroy
    has_many :received_chats, class_name: 'Stay::Chat', foreign_key: :receiver_id, dependent: :destroy
    has_many :addresses, class_name: 'Stay::Address'
    validates :phone, format: { with: /\A\d{10}\z/, message: "number must be valid." }

    accepts_nested_attributes_for :addresses, allow_destroy: true
    
    users_table_name = User.table_name
    roles_table_name = Role.table_name

    scope :admin, -> { includes(:stay_roles).where("#{roles_table_name}.name" => "admin") }

    attr_accessor :updating_password

    def roles
      stay_roles
    end

    def has_stay_role?(role_name)
      stay_roles.exists?(name: role_name)
    end

    def stay_admin?
      has_stay_role?('admin')
    end

    def name
      "#{first_name} #{last_name}"
    end

    def password_required?
      updating_password || super
    end
    
    private 

    def assign_default_role
      Stay::RoleUser.create(user: self, role: Stay::Role.where(name: Stay::Role::USER).first_or_create) unless stay_roles.exists?
    end

  end
end
