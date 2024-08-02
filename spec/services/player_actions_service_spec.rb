require 'rails_helper'

RSpec.describe PlayerActionsService do
  let(:session) { create(:session) }
  let(:hand) { create(:hand) }
  let(:spot) { create(:spot, session: session, hand: hand, player_cards: ['AH', 'AS']) }
  let(:service) { described_class.new(spot) }

  describe '#take_insurance' do
    it 'updates spot with insurance' do
      expect { service.take_insurance }.to change { spot.reload.insurance }.to(true)
    end
  end

  describe '#double_down' do
    it 'doubles the bet and hits once' do
      expect(service).to receive(:hit).and_call_original
      expect(spot.hand).to receive(:move_to_next_spot)
      
      expect {
        service.double
      }.to change { spot.double }.from(nil).to(true)
    end
  end

  describe '#hit' do
    it 'adds a card to player_cards' do
      expect { service.hit }.to change { spot.reload.player_cards.length }.by(1)
    end

    context 'when player busts' do
      it 'grades the hand and moves to next spot' do
        allow(spot).to receive(:busted?).and_return(true)
        expect_any_instance_of(GradingService).to receive(:grade!)
        expect(spot.hand).to receive(:move_to_next_spot)
        service.hit
      end
    end
  end

  describe '#split' do
    before do
      allow(spot).to receive(:split_offered?).and_return(true)
      allow(service).to receive(:deal_card).and_return('JH')
    end

    it 'creates two new spots from a pair' do
      expect {
        service.split
      }.to change { spot.reload.sub_spots.count }.by(2)
    end

    it 'sets the correct attributes for the new spots' do
      service.split
      sub_spots = spot.reload.sub_spots
      expect(sub_spots.first.player_cards).to eq(['AH', 'JH'])
      expect(sub_spots.second.player_cards).to eq(['AS', 'JH'])
      expect(sub_spots.first.wager).to eq(spot.wager)
      expect(sub_spots.second.wager).to eq(spot.wager)
      expect(sub_spots.first.spot_number).not_to be_nil
      expect(sub_spots.second.spot_number).not_to be_nil
    end

    it 'marks the original spot as split' do
      expect {
        service.split
      }.to change { spot.reload.split }.from(nil).to(true)
    end
  end
end
