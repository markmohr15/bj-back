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
FactoryBot.define do
  factory :session do
    user
    decks { 6 }
    stand_17 { true }
    penetration { 75 }
    num_spots { 5 }
    start_time { DateTime.now }
  end

end
