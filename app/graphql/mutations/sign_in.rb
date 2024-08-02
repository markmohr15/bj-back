module Mutations
  class SignIn < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(email:, password:)
      user = User.find_for_authentication(email: email)
      if user&.valid_password?(password)
        token = user.generate_jwt
        { 
          user: user, 
          token: token,
          errors: [] 
        }
      else
        {
          user: nil,
          token: nil,
          errors: 'Unable to authenticate'
        }      
      end
    end
  end
end
