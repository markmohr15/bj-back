# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include GraphqlAuthHelper
    
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :me, Types::UserType, null: true

    def me
      context[:current_user]
    end

    field :session, SessionType, null: true do
      argument :id, ID, required: true
    end

    def session(id:)
      Session.find(id)
    end

    field :current_user_sessions, [SessionType], null: false

    def current_user_sessions
      context[:current_user].sessions
    end

    field :active_hand, HandType, null: true do
      argument :session_id, ID, required: true
    end

    def active_hand(session_id:)
      session = Session.find(session_id)
      session.active_shoe.hands.last
    end

    field :active_session, SessionType, null: true

    def active_session
      context[:current_user].spots&.last&.session
    end

    field :last_ten_sessions, [Types::SessionType], null: false, description: "Returns the user's last 10 sessions"

    def last_ten_sessions
      return [] unless context[:current_user]
      context[:current_user].sessions.order(created_at: :desc).limit(10)
    end
    
  end
end
