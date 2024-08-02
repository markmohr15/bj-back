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
FactoryBot.define do
  factory :hand do
    association :shoe
    dealer_cards { ['AH', '7D'] } # Default dealer cards

    trait :blackjack do
      dealer_cards { ['AH', 'JS'] }
    end

    trait :soft_17 do
      dealer_cards { ['AH', '6D'] }
    end

    trait :hard_17 do
      dealer_cards { ['TH', '7S'] }
    end
  end
end
