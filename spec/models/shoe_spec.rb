require 'rails_helper'

RSpec.describe Shoe, type: :model do
  describe 'associations' do
    it { should belong_to(:session) }
    it { should have_many(:hands) }
  end

  describe 'validations' do
    it { should validate_presence_of(:client_seed) }
    it { should validate_presence_of(:shuffle_hash) }
  end

  describe 'serialization' do
    it { should serialize(:cards) }
  end

  describe 'scopes' do
    it 'active returns only active shoes' do
      active_shoe = create(:shoe)
      inactive_shoe = create(:shoe, :inactive)
      expect(Shoe.active).to include(active_shoe)
      expect(Shoe.active).not_to include(inactive_shoe)
    end
  end

  describe '#set_penetration_card' do
    let(:session) { create(:session, penetration: 80) }
    let(:shoe) { build(:shoe, session: session) }

    it 'sets the penetration_index based on session penetration' do
      expected_index = (shoe.cards.length * 0.80 - 1).round
      expect(shoe.penetration_index).to eq(expected_index)
    end
  end

  describe '#deal_card' do
    let(:shoe) { create(:shoe) }

    it 'returns the next card and increments the index' do
      first_card = shoe.cards.first
      expect(shoe.deal_card).to eq(first_card)
      expect(shoe.current_card_index).to eq(1)
    end

    it 'raises an error when there are no more cards' do
      shoe.update(current_card_index: shoe.cards.length)
      expect { shoe.deal_card }.to raise_error("No more cards in shoe")
    end
  end
end