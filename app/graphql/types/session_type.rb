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
    field :shoe_count, Integer, null: false
    field :hand_count, Integer, null: false
    field :spot_count, Integer, null: false
    field :profit, Float, null: false

    def active_shoe
      object.active_shoe
    end

    def profit
      object.profit_dollars
    end

    def shoe_count
      object.shoes.count
    end

    def hand_count
      object.hands.count
    end

    def spot_count
      object.spots.count
    end
  end
end