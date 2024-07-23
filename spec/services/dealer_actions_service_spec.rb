require 'rails_helper'

RSpec.describe DealerActionsService do
  let(:session) { create(:session) }
  let(:shoe) { create(:shoe, session: session) }
  let(:hand) { create(:hand, shoe: shoe) }
  let!(:spot) { create(:spot, hand: hand) }
  let(:service) { described_class.new(hand) }

  describe '#perform' do
    context 'when dealer has 16 or less' do
      it 'hits until dealer has more than 16' do
        allow(hand).to receive(:hand_value).and_return(15, 16, 18)
        expect(service).to receive(:hit).twice
        service.perform
      end
    end

    context 'when dealer has soft 17 and session.stand_17 is false' do
      it 'hits on soft 17' do
        hand.update! dealer_cards: ['AD', '6H']
        allow(shoe.session).to receive(:stand_17).and_return(false)
        allow(service).to receive(:deal_card).and_return('2S')
        expect(service).to receive(:hit).once.and_call_original
        service.perform
        expect(hand.dealer_cards).to eq(['AD', '6H', '2S'])
      end
    end

    context 'when dealer has soft 17 and session.stand_17 is true' do
      it 'hits on soft 17' do
        hand.update! dealer_cards: ['AD', '6H']
        allow(shoe.session).to receive(:stand_17).and_return(true)
        expect(service).to_not receive(:hit)
        service.perform
        expect(hand.dealer_cards).to eq(['AD', '6H'])
      end
    end

    it 'grades spots after dealer actions' do
      allow(hand).to receive(:hand_value).and_return(18)
      expect_any_instance_of(GradingService).to receive(:grade!)
      service.perform
    end
  end
end