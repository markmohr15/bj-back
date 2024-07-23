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