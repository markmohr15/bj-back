module Types
  class AnimatedCardType < Types::BaseObject
    field :spot_number, Integer, null: true
    field :card, String, null: false
  end
end