# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  jti                    :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("customer"), not null
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, 
         :recoverable, :validatable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence: true
  validates :email, length: { maximum: 255 }
  validates :email, format: { with: Regex::Email::VALIDATE }

  enum role: %i[customer admin]

  has_many :sessions
  has_many :shoes, through: :sessions
  has_many :spots
  has_many :hands, through: :spots

  # Send mail through activejob
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def generate_jwt
    JWT.encode({ id: id, exp: 12.hours.from_now.to_i }, Rails.application.credentials.fetch(:secret_key_base))
  end
  
end
