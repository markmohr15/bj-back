require 'rails_helper'

RSpec.describe Hand, type: :model do
  describe 'associations' do
    it { should belong_to(:shoe) }
    it { should belong_to(:current_spot).class_name('Spot').optional }
    it { should have_many(:spots).dependent(:destroy) }
  end

  describe 'serialization' do
    it { should serialize(:dealer_cards) }

    it 'serializes dealer_cards as JSON' do
      hand = create(:hand, dealer_cards: ['AH', 'JS'])
      hand.reload
      expect(hand.dealer_cards).to eq(['AH', 'JS'])
    end

    it 'allows assignment of an array to dealer_cards' do
      hand = build(:hand)
      expect { hand.dealer_cards = ['AH', 'JS'] }.not_to raise_error
    end
  end

  describe '#insurance_offered?' do
    it 'returns true when the first dealer card is an ace' do
      hand = create(:hand, dealer_cards: ['AS', '7H'])
      expect(hand.insurance_offered?).to be true
    end

    it 'returns false when the first dealer card is not an ace' do
      hand = create(:hand, dealer_cards: ['KS', '7H'])
      expect(hand.insurance_offered?).to be false
    end
  end

  describe '#move_to_next_spot' do
    let(:session) { create(:session) }
    let(:shoe) { create(:shoe, session: session) }
    let(:hand) { create(:hand, shoe: shoe) }
    let(:parent_spot) { create(:spot, hand: hand, session: session, split: true, player_cards: [], spot_number: 1) }
    let(:played_spot) { create(:spot, hand: hand, session: session, parent_spot: parent_spot, player_cards: ['6H', 'KS'], spot_number: 1) }
    let(:unplayed_spot) { create(:spot, hand: hand, session: session, parent_spot: parent_spot, player_cards: ['6D'], spot_number: 1) }

    before do
      hand.update(current_spot: played_spot)
    end

    context 'when there is an unplayed sibling' do
      it 'moves to the unplayed sibling spot and deals a card' do
        expect { hand.move_to_next_spot }.to change { hand.reload.current_spot }.from(played_spot).to(unplayed_spot)
        expect(unplayed_spot.reload.player_cards.length).to eq(2)
      end
    end

    context 'when there is no unplayed sibling' do
      let(:next_main_spot) { create(:spot, hand: hand, session: session, spot_number: 2) }

      before do
        unplayed_spot.update(player_cards: ['6D', 'JS', '7C'], result: 'loss')
        hand.spots << next_main_spot
      end

      it 'moves to the next main spot' do
        ActiveRecord::Base.transaction do
          expect(hand.spots.ordered_by_spot_number.map(&:id)).to eq([parent_spot.id, played_spot.id, unplayed_spot.id, next_main_spot.id])
          hand.move_to_next_spot
          expect(hand.reload.current_spot).to eq(next_main_spot)
        end
      end
    end

    context 'when there are no more spots to move to' do
      before do
        unplayed_spot.update(player_cards: ['6D', 'JS'])
        played_spot.update(result: 'win')
        unplayed_spot.update(result: 'loss')
      end

      it 'sets current_spot to nil' do
        expect { hand.move_to_next_spot }.to change { hand.reload.current_spot }.from(played_spot).to(nil)
      end

      it 'triggers dealer actions' do
        dealer_actions_service = instance_double(DealerActionsService)
        expect(DealerActionsService).to receive(:new).with(hand).and_return(dealer_actions_service)
        expect(dealer_actions_service).to receive(:perform)
        hand.move_to_next_spot
      end
    end
  end

  describe '#blackjack?' do
    it 'returns true for a blackjack hand' do
      hand = create(:hand, :blackjack)
      expect(hand.blackjack?).to be true
    end

    it 'returns false for a non-blackjack hand' do
      hand = create(:hand)
      expect(hand.blackjack?).to be false
    end
  end

  describe '#busted?' do
    it 'returns true when hand value is over 21' do
      hand = create(:hand, dealer_cards: ['KH', 'QS', '2D'])
      expect(hand.busted?).to be true
    end

    it 'returns false when hand value is 21 or under' do
      hand = create(:hand, dealer_cards: ['KH', 'QS'])
      expect(hand.busted?).to be false
    end
  end

  describe '#hand_value' do
    it 'correctly calculates hand value' do
      hand = create(:hand, dealer_cards: ['AH', 'JS'])
      expect(hand.hand_value).to eq 21
    end

    it 'correctly handles multiple aces' do
      hand = create(:hand, dealer_cards: ['AH', 'AS', '9S'])
      expect(hand.hand_value).to eq 21
    end
  end
end