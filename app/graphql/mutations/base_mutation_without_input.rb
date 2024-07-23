module Mutations
  class BaseMutationWithoutInput < GraphQL::Schema::Mutation
    null false
  end
end