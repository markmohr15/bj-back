require 'rails_helper'

RSpec.describe ShoeCreationService do
  let(:session) { create(:session, decks: 6) }
  let(:service) { described_class.new(session) }

  describe '#perform' do
    before do
      stub_request(:post, "http://python-service:8000/shuffle")
        .to_return(status: 200, body: { shuffled_cards: ['AH', 'KS', 'QD'], shuffle_hash: 'abc123' }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'creates a new shoe' do
      expect { service.perform }.to change(Shoe, :count).by(1)
    end

    it 'sets the correct attributes on the new shoe' do
      shoe = service.perform
      expect(shoe.cards).to eq(['AH', 'KS', 'QD'])
      expect(shoe.shuffle_hash).to eq('abc123')
      expect(shoe.client_seed).to be_present
    end
  end

  describe '#create_deck' do
    it 'creates the correct number of cards' do
      deck = service.send(:create_deck)
      expect(deck.length).to eq(52 * 6) # 6 decks
    end

    it 'includes all card types' do
      deck = service.send(:create_deck)
      expect(deck).to include('AH', '2C', 'TD', 'KS')
    end
  end
end