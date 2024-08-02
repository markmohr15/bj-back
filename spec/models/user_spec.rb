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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
  end

  describe 'associations' do
    it { should have_many(:sessions) }
    it { should have_many(:shoes).through(:sessions) }
    it { should have_many(:spots) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values([:customer, :admin]) }
  end

  describe '#generate_jwt' do
    let(:user) { create(:user) }

    it 'generates a JWT token' do
      token = user.generate_jwt
      decoded_token = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base), true, algorithm: 'HS256')
      expect(decoded_token.first['id']).to eq(user.id)
    end

    it 'sets expiration to 12 hours from now' do
      token = user.generate_jwt
      decoded_token = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base), true, algorithm: 'HS256')
      exp = Time.at(decoded_token.first['exp'])
      expect(exp).to be_within(1.minute).of(12.hours.from_now)
    end
  end
end
