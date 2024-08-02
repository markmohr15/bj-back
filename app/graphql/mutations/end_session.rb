module Mutations
  class EndSession < BaseMutation
    argument :id, ID, required: true

    field :session, Types::SessionType, null: true
    field :errors, [String], null: false

    def resolve(id:)
      authorized_resolve do |user|
        session = user.sessions.find id
        
        unless session
          return { success: false, errors: ["Session not found"] }
        end

        if session.end_time.nil?
          session.end_time = Time.current
          if session.save
            { session: session, errors: [] }
          else
            { session: nil, errors: session.errors.full_messages }
          end
        else
          { session: nil, errors: ["Session has already ended"] }
        end
      end
    end
  end
end