module Mutations
  class UpdateInsurance < BaseMutation
    argument :spot_id, ID, required: true
    argument :insurance, Boolean, required: true

    field :spot, Types::SpotType, null: true
    field :errors, [String], null: false

    def resolve(spot_id:, insurance:)
      authorized_resolve do |user|
        begin
          spot = user.spots.find spot_id
          service = PlayerActionsService.new spot
          
          result = if insurance
                     service.take_insurance
                   else
                     service.decline_insurance
                   end

          if result
            { spot: spot.reload, errors: [] }
          else
            action = insurance ? "take" : "decline"
            { spot: nil, errors: ["Unable to #{action} insurance"] }
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