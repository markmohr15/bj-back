module Types
  class HandType < Types::BaseObject
    field :id, ID, null: false
    field :dealer_cards, [String], null: false, method: :shown_dealer_cards
    field :shoe, Types::ShoeType, null: false
    field :current_spot_id, ID, null: true
    field :current_spot, Types::SpotType, null: true
    field :spots, [Types::SpotType], null: false
    field :ordered_spots, [Types::SpotType], null: false
    field :insurance_offered, Boolean, null: false
    
    def ordered_spots
      object.ordered_spots
    end

    def insurance_offered
      object.insurance_offered?
    end
  end
end