module Mutations
  class Split < BaseMutation
    argument :spot_id, ID, required: true

    field :spots, [Types::SpotType], null: true
    field :errors, [String], null: false

    def resolve(spot_id:)
      # need to use authorized_resolve here if using.
      # may just use player actions mutation.
      spot = Spot.find(spot_id)
      service = PlayerActionsService.new(spot)
      
      if service.split
        { spots: spot.sub_spots.reload, errors: [] }
      else
        { spots: nil, errors: ['Unable to split'] }
      end
    end
  end
end