module Mutations
  class DealHand < BaseMutation
    argument :session_id, ID, required: true
    argument :spots, [Types::SpotInputType], required: true

    field :success, Boolean, null: false
    field :hand, Types::HandType, null: true
    field :errors, [String], null: true

    def resolve(session_id:, spots:)
      authorized_resolve do |user|
        session = user.sessions.find_by_id session_id
        active_spots = nil

        ActiveRecord::Base.transaction do
          # Create or update spots
          active_spots = spots.map do |spot_input|
            next if spot_input.wager == 0
            spot = session.spots.active.find_or_initialize_by(spot_number: spot_input.spot_number)
            spot.update!(wager: spot_input.wager * 100, user: user)
            spot
          end
        end

        @hand = DealingService.new(session, active_spots.compact).perform

        {
          success: true,
          errors: [],
          hand: @hand
        }
      rescue ActiveRecord::RecordInvalid => e
        { success: false, errors: [e.message] }
      rescue => e
        { success: false, errors: ["An unexpected error occurred: #{e.message}"] }
      end
    end
  end
end