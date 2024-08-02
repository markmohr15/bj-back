module Mutations
  class BaseMutationWithoutInput < GraphQL::Schema::Mutation
    include GraphqlAuthHelper
    
    null false
  end
end