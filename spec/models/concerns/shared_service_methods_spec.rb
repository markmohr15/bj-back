require 'rails_helper'

RSpec.describe SharedServiceMethods do
  let(:test_class) do
    Class.new do
      include SharedServiceMethods
      attr_accessor :shoe
    end
  end

  let(:instance) { test_class.new }
  let(:mock_shoe) { instance_double("Shoe") }

  before do
    instance.shoe = mock_shoe
  end

  describe '#deal_card' do
    it 'calls deal_card on the shoe' do
      expect(mock_shoe).to receive(:deal_card).and_return('AH')
      expect(instance.deal_card).to eq('AH')
    end
  end
end