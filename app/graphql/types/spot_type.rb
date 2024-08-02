module Types
  class SpotType < Types::BaseObject
    field :id, ID, null: false
    field :wager, Float, null: false, method: :wager_in_dollars
    field :player_cards, [String], null: true
    field :result, String, null: true
    field :profit, Integer, null: false, method: :profit_in_dollars
    field :double, Boolean, null: true
    field :insurance, Boolean, null: true
    field :insurance_result, String, null: true
    field :split, Boolean, null: true
    field :spot_number, Integer, null: false
    field :hand, Types::HandType, null: true
    field :session, Types::SessionType, null: false
    field :user, Types::UserType, null: false
    field :parent_spot, Types::SpotType, null: true
    field :sub_spots, [Types::SpotType], null: false
    field :split_offered, Boolean, null: false
    field :is_blackjack, Boolean, null: false

    def split_offered
      object.split_offered?
    end

    def is_blackjack
      object.blackjack?
    end
  end
end