FactoryBot.define do
  factory :shoe do
    association :session

    client_seed { SecureRandom.hex(16) }
    shuffle_hash { SecureRandom.hex(32) }

    # Generate a full deck of cards
    cards do
      suits = %w[H D C S]
      values = %w[A 2 3 4 5 6 7 8 9 T J Q K]
      deck = suits.product(values).map { |suit, value| "#{value}#{suit}" }
      deck * 6 # Assuming 6 decks, adjust as needed
    end

    trait :inactive do
      active { false }
    end

    # Add a callback to ensure penetration_index is set
    after(:build) do |shoe|
      shoe.set_penetration_card if shoe.penetration_index.nil?
    end
  end
end