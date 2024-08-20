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
    field :session, Types::SessionType, null: false
    field :cards_to_animate, [Types::AnimatedCardType], null: false

    def ordered_spots
      object.ordered_spots
    end

    def insurance_offered
      object.insurance_offered?
    end

    def cards_to_animate
      cards = []
      
      object.ordered_spots.each do |spot|
        next if spot.player_cards.empty?
        cards << {
          card: spot.player_cards.first,
          spot_number: spot.spot_number
        }
      end

      if object.dealer_cards.any?
        cards << {
          card: object.dealer_cards.first,
          spot_number: nil
        }
      end

      object.ordered_spots.each do |spot|
        next if spot.player_cards.length < 2
        cards << {
          card: spot.player_cards[1],
          spot_number: spot.spot_number
        }
      end
      
      cards << {
        card: "",
        spot_number: nil
      }
      cards
    end
  end
end