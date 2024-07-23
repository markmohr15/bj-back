FactoryBot.define do
  factory :session do
    user
    decks { 6 }
    stand_17 { true }
    penetration { 75 }
    num_spots { 5 }
    start_time { DateTime.now }
  end

end