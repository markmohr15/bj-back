# == Schema Information
#
# Table name: spots
#
#  id               :bigint           not null, primary key
#  double           :boolean
#  insurance        :boolean
#  insurance_result :integer
#  player_cards     :text
#  profit           :integer          default(0)
#  result           :integer
#  split            :boolean
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
FactoryBot.define do
	factory :spot do
    hand
    user
    session
    wager { 10 }
    spot_number { (1..5).to_a.sample }
    player_cards { ["3S", "8D"] }

    trait :blackjack do
      player_cards { ["AS", "JH"] }
    end

    trait :soft_17 do
      player_cards { ["AH", "6D"] }
    end

    trait :hard_17 do
      player_cards { ["TH", "7S"] }
    end

    trait :bust do
      player_cards { ["TH", "7S", "5D"] }
    end

    trait :split do
      player_cards { ["TH"] }
      split { true }
    end
  end
end
