module Mutations
  class CreateSession < BaseMutation
    argument :decks, Integer, required: true
    argument :num_spots, Integer, required: true
    argument :penetration, Integer, required: true
    argument :six_five, Boolean, required: true
    argument :stand_17, Boolean, required: true

    field :session, Types::SessionType, null: true
    field :errors, [String], null: false

    def resolve(decks:, num_spots:, penetration:, six_five:, stand_17:)
      authorized_resolve do |user|

        session = user.sessions.new(
          decks: decks,
          num_spots: num_spots,
          penetration: penetration,
          six_five: six_five,
          stand_17: stand_17
        )

        if session.save
          { session: session, errors: [] }
        else
          { session: nil, errors: session.errors.full_messages }
        end
      end
    end
  end
end