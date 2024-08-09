module Types
  class ShoeType < Types::BaseObject
    field :id, ID, null: false
    field :active, Boolean, null: false
    field :current_card_index, Integer, null: false
    field :penetration_index, Integer, null: false
    field :session, Types::SessionType, null: false
    field :hands, [Types::HandType], null: false
    field :shuffle, Boolean, null: false
    field :discarded_cards, Integer, null: false

    def shuffle
      object.current_card_index >= object.penetration_index
    end

    def discarded_cards
      shuffle ? 0 : object.current_card_index
    end
  end
end