module Mutations
  class RefreshToken < BaseMutationWithoutInput
    field :token, String, null: true
    field :errors, [String], null: false

		def refresh_token
		  if context[:current_user]
		    token = context[:current_user].generate_jwt
        {
          token: token,
          errors: [] 
        }
		  else
		    {
		    	token: nil,
		    	errors: "User not authenticated"
		    }
		  end
		end
	end
end