# == Schema Information
#
# Table name: sessions
#
#  id          :bigint           not null, primary key
#  decks       :integer
#  double_any  :boolean          default(TRUE)
#  early_sur   :boolean          default(FALSE)
#  end_time    :datetime
#  late_sur    :boolean          default(FALSE)
#  num_spots   :integer
#  penetration :integer
#  six_five    :boolean          default(FALSE)
#  stand_17    :boolean          default(FALSE)
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Session < ApplicationRecord
  belongs_to :user
  has_many :shoes, dependent: :destroy
  has_many :spots, dependent: :destroy
  has_many :hands, through: :shoes

  validates :decks, presence: true, numericality: { 
    greater_than: 0, less_than_or_equal_to: 8 }

  validates :penetration, presence: true, numericality: {
    greater_than_or_equal_to: 10, less_than_or_equal_to: 90 }

  validates :num_spots, presence: true, numericality: {
    greater_than_or_equal_to: 1, less_than_or_equal_to: 6 }

  scope :active, -> { where end_time: nil }

  def active_shoe
    shoes.active.first || ShoeCreationService.new(self).perform
  end

  def profit_cents
    spots.sum(:profit)
  end

  def profit_dollars
    profit_cents / 100.0
  end

end
