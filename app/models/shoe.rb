# == Schema Information
#
# Table name: shoes
#
#  id                 :bigint           not null, primary key
#  active             :boolean          default(TRUE)
#  cards              :text
#  client_seed        :string
#  current_card_index :integer          default(0)
#  penetration_index  :integer
#  shuffle_hash       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  session_id         :bigint           not null
#
# Indexes
#
#  index_shoes_on_session_id  (session_id)
#
# Foreign Keys
#
#  fk_rails_...  (session_id => sessions.id)
#
class Shoe < ApplicationRecord
  belongs_to :session
  has_many :hands

  serialize :cards, coder: JSON

  before_create :set_penetration_card

  validates_presence_of :client_seed, :shuffle_hash

  scope :active, -> { where(active: true) }

  def set_penetration_card
    penetration = session.penetration * 0.01
    self.penetration_index = (cards.length * penetration - 1).round
  end

  def deal_card
    raise "No more cards in shoe" if current_card_index >= cards.length
    card = cards[current_card_index]
    self.update! current_card_index: current_card_index + 1
    card
  end
end
