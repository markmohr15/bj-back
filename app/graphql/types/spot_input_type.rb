module Types
  class SpotInputType < Types::BaseInputObject
    argument :spot_number, Integer, required: true
    argument :wager, Integer, required: true
  end
end