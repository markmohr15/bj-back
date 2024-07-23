require 'rails_helper'

RSpec.describe DealingService do
  let(:session) { create(:session) }
  let(:shoe) { create(:shoe, session: session) }
  let!(:spot) { create(:spot, session: session, player_cards: [], hand: nil) }
  let(:service) { described_class.new(session) }

  before do
    allow(session).to receive(:active_shoe).and_return(shoe)
  end

  describe '#perform' do
    it 'creates a new hand' do
      expect { service.perform }.to change(Hand, :count).by(1)
    end

    it 'deals cards to spots and dealer' do
      service.perform
      expect(spot.reload.player_cards.length).to eq(2)
      expect(spot.hand.dealer_cards.length).to eq(2)
    end

    it 'checks for blackjacks' do
      expect(service).to receive(:initial_check_for_blackjack)
      service.perform
    end
  end

  describe '#ensure_valid_shoe' do
    before do
      stub_request(:post, "http://python-service:8000/shuffle")
        .to_return(status: 200, body: { shuffled_cards: ['AH', 'KS', 'QD'], shuffle_hash: 'abc123' }.to_json, headers: { 'Content-Type' => 'application/json' })
    end
    
    context 'when shoe is invalid' do
      it 'creates a new shoe' do
        allow(service).to receive(:can_deal?).and_return(false)
        expect(ShoeCreationService).to receive(:new).and_call_original
        service.send(:ensure_valid_shoe)
      end
    end
  end
end