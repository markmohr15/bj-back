module Types
  class ShoeType < Types::BaseObject
    field :id, ID, null: false
    field :active, Boolean, null: false
    field :current_card_index, Integer, null: false
    field :penetration_index, Integer, null: false
    field :session, Types::SessionType, null: false
    field :hands, [Types::HandType], null: false
  end
end