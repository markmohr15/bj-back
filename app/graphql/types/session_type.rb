module Types
  class SessionType < Types::BaseObject
    field :id, ID, null: false
    field :decks, Integer, null: false
    field :penetration, Integer, null: false
    field :num_spots, Integer, null: false
    field :stand_17, Boolean, null: false
    field :early_sur, Boolean, null: false
    field :late_sur, Boolean, null: false
    field :six_five, Boolean, null: false
    field :start_time, GraphQL::Types::ISO8601DateTime, null: true
    field :end_time, GraphQL::Types::ISO8601DateTime, null: true
    field :user, Types::UserType, null: false
    field :spots, [Types::SpotType], null: false
    field :hands, [Types::HandType], null: false
    field :active_shoe, Types::ShoeType, null: true
    field :hands_played, Integer, null: false
    field :profit_cents, Float, null: false

    def active_shoe
      object.active_shoe
    end

    def hands_played
      object.spots.count
    end

    def profit_cents
      object.profit_cents
    end
  end
end