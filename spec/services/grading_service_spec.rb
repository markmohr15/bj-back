require 'rails_helper'

RSpec.describe GradingService do
  let(:session) { create(:session) }
  let(:hand) { create(:hand) }
  let(:spot) { create(:spot, hand: hand, session: session) }
  let(:service) { described_class.new(spot) }

  describe '#grade!' do
    context 'when player has blackjack' do
      before { allow(spot).to receive(:blackjack?).and_return(true) }

      it 'handles player blackjack vs dealer blackjack' do
        hand.update! dealer_cards: ["AD", "TH"]
        expect { service.grade! }.to change { spot.reload.result }.to('push')
      end

      it 'handles player blackjack vs dealer non-blackjack' do
        allow(hand).to receive(:blackjack?).and_return(false)
        expect { service.grade! }.to change { spot.reload.result }.to('win')
      end
    end

    context 'when player busts' do
      it 'marks as loss' do
        allow(spot).to receive(:busted?).and_return(true)
        expect { service.grade! }.to change { spot.reload.result }.to('loss')
      end
    end

    context 'when player splits' do
      it 'marks as split_hand' do
        allow(spot).to receive(:split?).and_return(true)
        expect { service.grade! }.to change { spot.reload.result }.to('split_hand')
      end
    end
  end
end