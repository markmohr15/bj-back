# == Schema Information
#
# Table name: spots
#
#  id               :bigint           not null, primary key
#  double           :boolean
#  insurance        :boolean
#  insurance_result :integer
#  player_cards     :text
#  profit           :integer          default(0)
#  result           :integer
#  split            :boolean
#  spot_number      :integer
#  wager            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  hand_id          :bigint
#  parent_spot_id   :bigint
#  session_id       :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_spots_on_hand_id         (hand_id)
#  index_spots_on_parent_spot_id  (parent_spot_id)
#  index_spots_on_session_id      (session_id)
#  index_spots_on_split           (split)
#  index_spots_on_spot_number     (spot_number)
#  index_spots_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (hand_id => hands.id)
#  fk_rails_...  (parent_spot_id => spots.id)
#  fk_rails_...  (session_id => sessions.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Spot, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:session) }
    it { should belong_to(:hand).optional }
    it { should belong_to(:parent_spot).class_name('Spot').optional }
    it { should have_many(:sub_spots).class_name('Spot').with_foreign_key('parent_spot_id') }
  end

  describe 'serialization' do
    it { should serialize(:player_cards) }

    it 'serializes player_cards as JSON' do
      spot = create(:spot, player_cards: ['AH', 'JS'])
      spot.reload
      expect(spot.player_cards).to eq(['AH', 'JS'])
    end

    it 'allows assignment of an array to player_cards' do
      spot = build(:spot)
      expect { spot.player_cards = ['AH', 'JS'] }.not_to raise_error
    end
  end

  describe 'enums' do
    it { should define_enum_for(:result).with_values(win: 0, loss: 1, push: 2, split_hand: 3, bj: 4).backed_by_column_of_type(:integer) }
    it { should define_enum_for(:insurance_result).with_values(ins_win: 0, ins_loss: 1).backed_by_column_of_type(:integer) }
  end

  describe 'validations' do
    it { should validate_presence_of(:wager) }
    it { should validate_numericality_of(:wager).is_greater_than(0) }
    it { should validate_presence_of(:spot_number) }
    it { should validate_numericality_of(:spot_number).is_greater_than(0).is_less_than_or_equal_to(6) }
  
    it 'allows valid result values' do
      spot = build(:spot)
      expect(spot).to allow_value('win').for(:result)
      expect(spot).to allow_value('loss').for(:result)
      expect(spot).to allow_value('push').for(:result)
      expect(spot).to allow_value('split_hand').for(:result)
      expect(spot).to allow_value('bj').for(:result)
      expect(spot).to allow_value(nil).for(:result)
    end

    it 'does not allow invalid result values' do
      spot = build(:spot)
      expect { spot.result = 'invalid_value' }.to raise_error(ArgumentError)
      expect { spot.result = 123 }.to raise_error(ArgumentError)
    end

    it 'allows valid ins_result values' do
      spot = build(:spot)
      expect(spot).to allow_value('ins_win').for(:insurance_result)
      expect(spot).to allow_value('ins_loss').for(:insurance_result)
      expect(spot).to allow_value(nil).for(:insurance_result)
    end

    it 'does not allow invalid result values' do
      spot = build(:spot)
      expect { spot.insurance_result = 'invalid_value' }.to raise_error(ArgumentError)
      expect { spot.insurance_result = 123 }.to raise_error(ArgumentError)
    end
  end

  describe 'scopes' do
    let!(:active_spot) { create(:spot, hand: nil) }
    let!(:in_progress_spot) { create(:spot, result: nil) }
    let!(:completed_spot) { create(:spot, result: :win) }

    it 'active returns spots without a hand' do
      expect(Spot.active).to include(active_spot)
      expect(Spot.active).not_to include(in_progress_spot, completed_spot)
    end

    it 'in_progress returns spots without a result' do
      expect(Spot.in_progress).to include(in_progress_spot)
      expect(Spot.in_progress).not_to include(completed_spot)
    end
  end

  describe '#split_offered?' do
    let(:spot) { create(:spot) }

    it 'returns true for a pair' do
      spot.player_cards = ['AS', 'AH']
      expect(spot.split_offered?).to be true
    end

    it 'returns false for non-pair cards' do
      spot.player_cards = ['AS', 'KH']
      expect(spot.split_offered?).to be false
    end

    it 'returns false if the spot has a result' do
      spot.player_cards = ['AS', 'AH']
      spot.result = :win
      expect(spot.split_offered?).to be false
    end
  end

  describe '#set_session_start_time' do
    let(:session) { create(:session, start_time: nil) }
    let(:spot) { build(:spot, session: session) }

    it 'sets the session start time if not already set' do
      expect { spot.save }.to change { session.reload.start_time }.from(nil)
    end

    it 'does not change the session start time if already set' do
      session.update(start_time: 1.hour.ago)
      expect { spot.save }.not_to change { session.reload.start_time }
    end
  end
end
