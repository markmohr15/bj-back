module Types
	class UserType < Types::BaseObject
		field :id, ID, null: false
		field :email, String, null: false
		field :current_active_session, Types::SessionType, null: true

    def current_active_session
      object.sessions.active.find_by(end_time: nil)
    end
	end
end