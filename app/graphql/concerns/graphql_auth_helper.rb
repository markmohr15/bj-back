module GraphqlAuthHelper
  extend ActiveSupport::Concern

  private

  def authenticate_user!
    unless context[:current_user]
      raise GraphQL::ExecutionError.new("You must be logged in to perform this action", extensions: { code: 'UNAUTHENTICATED' })
    end
    context[:current_user]
  end

  def authorized_resolve
    user = authenticate_user!
    yield(user)
  rescue GraphQL::ExecutionError => e
    { errors: [e.message] }
  rescue StandardError => e
    { errors: ["An unexpected error occurred: #{e.message}"] }
  end
end