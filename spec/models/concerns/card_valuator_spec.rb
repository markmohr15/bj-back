require 'rails_helper'

RSpec.describe CardValuator do
  let(:test_class) do
    Class.new do
      include CardValuator
      attr_accessor :test_cards
      valuate_cards :test_cards
    end
  end

  let(:instance) { test_class.new }

  describe '#hand_value' do
    it 'calculates hand value correctly' do
      instance.test_cards = ['AH', 'JS']
      expect(instance.hand_value).to eq 21

      instance.test_cards = ['7H', '8S', '6D']
      expect(instance.hand_value).to eq 21

      instance.test_cards = ['AH', 'AS', '9S']
      expect(instance.hand_value).to eq 21

      instance.test_cards = ['KH', 'QS', 'JD']
      expect(instance.hand_value).to eq 30
    end

    it 'returns 0 for empty or nil cards' do
      instance.test_cards = []
      expect(instance.hand_value).to eq 0

      instance.test_cards = nil
      expect(instance.hand_value).to eq 0
    end
  end

  describe '#ten_ace?' do
    it 'returns true for ten-ace combination' do
      instance.test_cards = ['TH', 'AS']
      expect(instance.ten_ace?).to be true
    end

    it 'returns false for other combinations' do
      instance.test_cards = ['AH', 'JS']
      expect(instance.ten_ace?).to be false
    end
  end

  describe '#blackjack?' do
    it 'returns true for blackjack' do
      instance.test_cards = ['AH', 'JS']
      expect(instance.blackjack?).to be true
    end

    it 'returns false for non-blackjack' do
      instance.test_cards = ['AH', 'JH', '2S']
      expect(instance.blackjack?).to be false
    end

    context 'when instance is a Spot' do
      let(:spot_class) do
        Class.new do
          include CardValuator
          attr_accessor :player_cards, :parent_spot
          valuate_cards :player_cards

          def is_a?(klass)
            klass == Spot
          end
        end
      end

      let(:spot) { spot_class.new }

      it 'returns false for split hands' do
        spot.player_cards = ['AH', 'JS']
        spot.parent_spot = double('ParentSpot')
        expect(spot.blackjack?).to be false
      end
    end
  end

  describe '#busted?' do
    it 'returns true when hand value is over 21' do
      instance.test_cards = ['KH', 'QS', '2D']
      expect(instance.busted?).to be true
    end

    it 'returns false when hand value is 21 or under' do
      instance.test_cards = ['KH', 'QS']
      expect(instance.busted?).to be false
    end
  end

  describe '#soft_hand?' do
    it 'returns true for soft hands' do
      instance.test_cards = ['AH', '6D']
      expect(instance.soft_hand?).to be true
    end

    it 'returns false for hard hands' do
      instance.test_cards = ['KH', '6D']
      expect(instance.soft_hand?).to be false
    end

    it 'returns false for busted hands with an ace' do
      instance.test_cards = ['AH', 'KS', 'QD']
      expect(instance.soft_hand?).to be false
    end
  end
end