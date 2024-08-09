# == Schema Information
#
# Table name: hands
#
#  id              :bigint           not null, primary key
#  dealer_cards    :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_spot_id :bigint
#  shoe_id         :bigint           not null
#
# Indexes
#
#  index_hands_on_current_spot_id  (current_spot_id)
#  index_hands_on_shoe_id          (shoe_id)
#
# Foreign Keys
#
#  fk_rails_...  (current_spot_id => spots.id)
#  fk_rails_...  (shoe_id => shoes.id)
#
class Hand < ApplicationRecord
  include CardValuator
  valuate_cards :dealer_cards

  belongs_to :shoe
  belongs_to :current_spot, class_name: "Spot", optional: true
  has_one :session, through: :shoe
  has_many :spots, dependent: :destroy
  has_many :ordered_spots, -> { ordered_by_spot_number }, class_name: "Spot"
  has_many :users, through: :spots

  serialize :dealer_cards, coder: JSON

  def insurance_offered?
    dealer_cards.present? && Card.is_ace?(dealer_cards.first)
  end

  def move_to_next_spot
    update! current_spot: find_next_spot
  end

  def shown_dealer_cards
    current_spot.nil? ? dealer_cards : [dealer_cards[0]]
  end

  private

  def find_next_spot
    return nil if current_spot.nil?

    if current_spot.parent_spot
      sibling_spot = find_unplayed_sibling
      if sibling_spot
        sibling_spot.player_cards << shoe.deal_card
        sibling_spot.save!
        return sibling_spot 
      end
    end

    find_next_main_spot    
  end

  def find_unplayed_sibling
    return nil unless current_spot && current_spot.parent_spot
    current_spot.parent_spot.sub_spots.find { |spot| spot.player_cards.length == 1 }
  end

  def find_next_main_spot
    current_index = ordered_spots.index(current_spot)
    next_spot = nil
    unplayed = false
    while !unplayed
      current_index += 1
      return nil if current_index == ordered_spots.size
      next_spot = ordered_spots[current_index]
      unplayed = true if next_spot.result.nil?
    end

    next_spot
  end
end
