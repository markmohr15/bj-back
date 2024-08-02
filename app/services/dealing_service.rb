class DealingService
  include SharedServiceMethods

  def initialize(session, spots = nil)
    @session = session
    @shoe = session.active_shoe
    @spots = spots || session.spots.active
  end

  def perform
    ensure_valid_shoe
    @hand = deal_new_hand
    initial_check_for_blackjack
    @hand
  end

  private

  def ensure_valid_shoe
    if !@shoe || !can_deal?
      @shoe.update!(active: false) if @shoe
      @shoe = ShoeCreationService.new(@session).perform
    end
  end

  def can_deal?
    @shoe.current_card_index < @shoe.penetration_index
  end

  def deal_new_hand
    return if @spots.empty?

    ActiveRecord::Base.transaction do
      hand = @shoe.hands.create!
      @spots.each do |spot|
        spot.player_cards = [deal_card]
      end
      hand.dealer_cards = [deal_card]
      @spots.each do |spot|
        spot.player_cards << deal_card
        spot.hand = hand
        spot.save!
      end
      hand.dealer_cards << deal_card
      hand.current_spot = @spots.first
      hand.save!
      hand
    end
  end

  def initial_check_for_blackjack
    initial_check_for_dealer_blackjack if @hand
    initial_check_for_player_blackjack if @spots.any?
  end

  def initial_check_for_dealer_blackjack
    return unless @hand.ten_ace?
    ActiveRecord::Base.transaction do
      @hand.update! current_spot: nil
      @spots.each do |spot|
        GradingService.new(spot).grade!
      end
    end
  end

  def initial_check_for_player_blackjack
    return if @hand.ten_ace?
    return if @hand.insurance_offered?
    ActiveRecord::Base.transaction do
      @spots.each do |spot|
        if spot.blackjack?
          GradingService.new(spot).grade! 
          @hand.move_to_next_spot if spot == @hand.current_spot
        end
      end
    end
  end

end