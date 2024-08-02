module Mutations
  class PlayerActions < BaseMutation
    argument :spot_id, ID, required: true
    argument :action, String, required: true

    field :spot, Types::SpotType, null: true
    field :errors, [String], null: false

    ALLOWED_ACTIONS = %w[hit stand double].freeze

    def resolve(spot_id:, action:)
      unless ALLOWED_ACTIONS.include? action
        return { spot: nil, errors: ["Invalid action: #{action}"] }
      end

      authorized_resolve do |user|
        begin
          spot = user.spots.find spot_id
          service = PlayerActionsService.new spot
          
          result = case action
                   when "hit"
                     service.hit
                   when "stand"
                     service.stand
                   when "double"
                     service.double
                   end

          if result
            { spot: spot.reload, errors: [] }
          else
            { spot: nil, errors: ["Unable to #{action}"] }
          end
        rescue ActiveRecord::RecordNotFound
          { spot: nil, errors: ["Spot not found"] }
        rescue StandardError => e
          { spot: nil, errors: ["An unexpected error occurred: #{e.message}"] }
        end
      end
    end
  end
end