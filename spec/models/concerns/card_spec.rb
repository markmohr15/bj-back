require 'rails_helper'

RSpec.describe Card do
  describe '.value' do
    it 'returns correct value for number cards' do
      expect(Card.value('2H')).to eq 2
      expect(Card.value('9S')).to eq 9
    end

    it 'returns 10 for face cards' do
      expect(Card.value('TH')).to eq 10
      expect(Card.value('JD')).to eq 10
      expect(Card.value('QC')).to eq 10
      expect(Card.value('KS')).to eq 10
    end

    it 'returns 11 for Ace' do
      expect(Card.value('AH')).to eq 11
    end
  end

  describe '.is_ten?' do
    it 'returns true for ten-value cards' do
      expect(Card.is_ten?('TH')).to be true
      expect(Card.is_ten?('JS')).to be true
      expect(Card.is_ten?('QD')).to be true
      expect(Card.is_ten?('KC')).to be true
    end

    it 'returns false for non-ten-value cards' do
      expect(Card.is_ten?('9H')).to be false
      expect(Card.is_ten?('AH')).to be false
    end
  end

  describe '.is_ace?' do
    it 'returns true for Ace' do
      expect(Card.is_ace?('AH')).to be true
    end

    it 'returns false for non-Ace cards' do
      expect(Card.is_ace?('KH')).to be false
      expect(Card.is_ace?('2S')).to be false
    end
  end

  describe '.suit' do
    it 'returns the correct suit' do
      expect(Card.suit('AH')).to eq 'H'
      expect(Card.suit('2S')).to eq 'S'
      expect(Card.suit('TD')).to eq 'D'
      expect(Card.suit('KC')).to eq 'C'
    end
  end
end