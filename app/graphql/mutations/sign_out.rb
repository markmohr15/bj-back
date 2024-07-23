module Mutations
  class SignOut < BaseMutationWithoutInput
    null true

    field :success, Boolean, null: false

    def resolve
      if context[:current_user]
        # Update the JTI to invalidate all current tokens
        context[:current_user].update!(jti: SecureRandom.uuid)
        
        # Clear any session data if you're using it
        context[:session]&.clear
        
        { success: true }
      else
        { success: false }
      end
    end
  end
end