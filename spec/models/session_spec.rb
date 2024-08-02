# == Schema Information
#
# Table name: sessions
#
#  id          :bigint           not null, primary key
#  decks       :integer
#  double_any  :boolean          default(TRUE)
#  early_sur   :boolean          default(FALSE)
#  end_time    :datetime
#  late_sur    :boolean          default(FALSE)
#  num_spots   :integer
#  penetration :integer
#  six_five    :boolean          default(FALSE)
#  stand_17    :boolean          default(FALSE)
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:shoes).dependent(:destroy) }
    it { should have_many(:spots).dependent(:destroy) }
    it { should have_many(:hands).through(:shoes) }
  end

  describe 'validations' do
    it { should validate_presence_of(:decks) }
    it { should validate_numericality_of(:decks).is_greater_than(0).is_less_than_or_equal_to(8) }
    it { should validate_presence_of(:penetration) }
    it { should validate_numericality_of(:penetration).is_greater_than_or_equal_to(10).is_less_than_or_equal_to(90) }
  end

  describe '#active_shoe' do
    let(:session) { create(:session) }
    let!(:active_shoe) { create(:shoe, session: session, active: true) }
    let!(:inactive_shoe) { create(:shoe, session: session, active: false) }

    context 'when there is an active shoe' do
      it 'returns the active shoe' do
        expect(session.active_shoe).to eq(active_shoe)
      end
    end

    context 'when there is no active shoe' do
      before do
        # Ensure no active shoes exist
        session.shoes.update_all(active: false)

        stub_request(:post, "http://python-service:8000/shuffle")
          .to_return(status: 200, body: {
            shuffled_cards: (1..312).map { |_| "AH" },
            shuffle_hash: "example_hash"
          }.to_json, headers: {'Content-Type' => 'application/json'})
      end

      it 'creates a new shoe' do
        expect(session.shoes.active).to be_empty

        result = nil
        expect {
          result = session.active_shoe
        }.to change { session.shoes.active.count }.from(0).to(1)

        expect(result).to be_a(Shoe)
        expect(result).to be_active
        expect(result.session).to eq(session)
      end
    end
  end
end
