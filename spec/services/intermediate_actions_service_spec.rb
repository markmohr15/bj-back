require 'rails_helper'

RSpec.describe IntermediateActionsService do
  let(:session) { create(:session) }
  let(:hand) { create(:hand) }
  let(:spot1) { create(:spot, hand: hand, session: session) }
  let(:spot2) { create(:spot, hand: hand, session: session) }
  let(:service) { described_class.new(hand) }

  before do
    allow(hand).to receive(:spots).and_return([spot1, spot2])
    allow(hand).to receive(:current_spot).and_return(spot1)
  end

  describe '#perform' do
    context 'when dealer has blackjack' do
      before do
        allow(hand).to receive(:blackjack?).and_return(true)
      end

      it 'grades all spots' do
        expect(service).to receive(:grade_spot).twice
        service.perform
      end

      it 'sets current_spot to nil' do
        expect(hand).to receive(:update).with(current_spot: nil)
        service.perform
      end

      it 'grades insurance for insured spots' do
        spot1.update(insurance: true)
        expect(service).to receive(:grade_insurance).with(spot1)
        expect(service).to receive(:grade_insurance).with(spot2)
        service.perform
      end
    end

    context 'when a player has blackjack' do
      before do
        allow(spot1).to receive(:blackjack?).and_return(true)
        allow(hand).to receive(:blackjack?).and_return(false)
      end

      it 'grades the blackjack spot' do
        expect(service).to receive(:grade_spot).once
        service.perform
      end

      it 'moves to the next spot' do
        expect(service).to receive(:move_to_next_spot)
        service.perform
      end
    end

    context 'when no blackjacks' do
      before do
        allow(hand).to receive(:blackjack?).and_return(false)
        allow(spot1).to receive(:blackjack?).and_return(false)
        allow(spot2).to receive(:blackjack?).and_return(false)
      end

      it 'does not grade any spots' do
        expect(service).not_to receive(:grade_spot)
        service.perform
      end

      it 'does not move to the next spot' do
        expect(service).not_to receive(:move_to_next_spot)
        service.perform
      end
    end
  end

  describe '#grade_insurance' do
    context 'when spot has insurance' do
      before do
        spot1.update(insurance: true)
      end

      it 'grades insurance as win when dealer has blackjack' do
        allow(hand).to receive(:blackjack?).and_return(true)
        expect(spot1).to receive(:update!).with(insurance_result: "ins_win", profit: spot1.wager)
        service.send(:grade_insurance, spot1)
      end

      it 'grades insurance as loss when dealer does not have blackjack' do
        allow(hand).to receive(:blackjack?).and_return(false)
        expect(spot1).to receive(:update!).with(insurance_result: "ins_loss", profit: spot1.wager / 2.0)
        service.send(:grade_insurance, spot1)
      end
    end

    context 'when spot does not have insurance' do
      it 'does not grade insurance' do
        expect(spot1).not_to receive(:update!)
        service.send(:grade_insurance, spot1)
      end
    end
  end
end