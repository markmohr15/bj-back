module Mutations
  class IntermediateActions < BaseMutation
    argument :hand_id, ID, required: true

    field :hand, Types::HandType, null: true
    field :errors, [String], null: false


    def resolve(hand_id:)
      authorized_resolve do |user|
        begin
          hand = user.hands.find hand_id
          service = IntermediateActionsService.new hand
          
          if service.perform
            { hand: hand.reload, errors: [] }
          else
            { hand: nil, errors: ["Unable to perform intermediate actions"] }
          end
        rescue ActiveRecord::RecordNotFound
          { spot: nil, errors: ["Hand not found"] }
        rescue StandardError => e
          { spot: nil, errors: ["An unexpected error occurred: #{e.message}"] }
        end
      end
    end
  end
end