# == Schema Information
#
# Table name: spots
#
#  id               :bigint           not null, primary key
#  double           :boolean          default(FALSE)
#  insurance        :boolean          default(FALSE)
#  insurance_result :integer
#  player_cards     :text
#  profit           :integer          default(0)
#  result           :integer
#  split            :boolean          default(FALSE)
#  spot_number      :integer
#  wager            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  hand_id          :bigint
#  parent_spot_id   :bigint
#  session_id       :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_spots_on_hand_id         (hand_id)
#  index_spots_on_parent_spot_id  (parent_spot_id)
#  index_spots_on_session_id      (session_id)
#  index_spots_on_split           (split)
#  index_spots_on_spot_number     (spot_number)
#  index_spots_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (hand_id => hands.id)
#  fk_rails_...  (parent_spot_id => spots.id)
#  fk_rails_...  (session_id => sessions.id)
#  fk_rails_...  (user_id => users.id)
#
class Spot < ApplicationRecord
  include CardValuator
  valuate_cards :player_cards

  belongs_to :user
  belongs_to :session
  belongs_to :hand, optional: true
  belongs_to :parent_spot, class_name: 'Spot', optional: true

  has_many :sub_spots, class_name: 'Spot', foreign_key: 'parent_spot_id'

  serialize :player_cards, coder: JSON

  after_create :set_session_start_time

  enum result: { win: 0, loss: 1, push: 2, split_hand: 3 }
  enum insurance_result: { ins_win: 0, ins_loss: 1 }
  
  validates :wager, presence: true, numericality: { greater_than: 0 }
  validates :spot_number, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 6 }
  validates :result, inclusion: { in: Spot.results.keys }, allow_nil: true
  validates :insurance_result, inclusion: { in: Spot.insurance_results.keys }, allow_nil: true

  scope :active, -> { where(hand_id: nil).order(:spot_number) }
  scope :in_progress, -> { where(result: nil).order(:spot_number) }
  scope :ordered_by_spot_number, -> { order(:spot_number) }

  def split_offered?
    player_cards.present? && player_cards.length == 2 && result.nil? &&
    Card.value(player_cards.first) == Card.value(player_cards.second)
  end

  def set_session_start_time
    session.update!(start_time: DateTime.now) if session.start_time.nil?
  end
end
