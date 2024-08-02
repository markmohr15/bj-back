# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_up, mutation: Mutations::SignUp
    field :sign_in, mutation: Mutations::SignIn
    field :sign_out, mutation: Mutations::SignOut
    field :refresh_token, mutation: Mutations::RefreshToken
    field :create_session, mutation: Mutations::CreateSession
    field :deal_hand, mutation: Mutations::DealHand
    field :end_session, mutation: Mutations::EndSession
    field :player_actions, mutation: Mutations::PlayerActions
    field :split, mutation: Mutations::Split
    field :update_insurance, mutation: Mutations::UpdateInsurance
    field :insure_spots, mutation: Mutations::InsureSpots
    field :dealer_actions, mutation: Mutations::DealerActions
    field :intermediate_actions, mutation: Mutations::IntermediateActions
  end
end
