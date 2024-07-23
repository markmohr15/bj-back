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