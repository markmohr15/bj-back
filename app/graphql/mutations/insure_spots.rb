module Mutations
  class InsureSpots < BaseMutation
    argument :spots, [Types::SpotInsuranceInputType], required: true

    field :spots, [Types::SpotType], null: true
    field :errors, [String], null: true

    def resolve(spots:)
      authorized_resolve do |user|
        begin
          insured_spots = []
          errors = []

          Spot.transaction do
            spots.each do |spot_input|
              spot = user.spots.find spot_input.id
              begin
                spot.update!(insurance: spot_input.insurance)
                insured_spots << spot
              rescue ActiveRecord::RecordInvalid => e
                errors << "Failed to insure spot #{spot_input.id}: #{e.message}"
              end
            end

            raise ActiveRecord::Rollback if errors.any?
          end

          if errors.any?
            { errors: errors, spots: nil }
          else
            { spots: insured_spots, errors: [] }
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
