module Types
  class SpotInsuranceInputType < Types::BaseInputObject
    argument :id, ID, required: true
    argument :insurance, Boolean, required: true
  end
end