class IntermediateActionsService
	def initialize(hand)
		@hand = hand
		@spots = hand.spots
		@session = @spots.first.session
	end

	def perform
    ActiveRecord::Base.transaction do
      @spots.each do |spot|
        grade_insurance(spot)
        grade_spot(spot) if should_grade_spot?(spot)
        move_to_next_spot(spot) if should_move_to_next_spot?(spot)
      end
      @hand.update current_spot: nil if @hand.blackjack?
    end
    @hand
	end

	private

	def grade_insurance(spot)
		return unless spot.insurance?
		if @hand.blackjack?
			spot.update! insurance_result: "ins_win", profit: spot.wager
		else
			spot.update! insurance_result: "ins_loss", 
									 profit: spot.wager / 2.0
		end
	end

  def should_grade_spot?(spot)
    @hand.blackjack? || spot.blackjack?
  end

  def grade_spot(spot)
    GradingService.new(spot).grade!
  end

  def should_move_to_next_spot?(spot)
    spot == @hand.current_spot && spot.blackjack? && !@hand.blackjack?
  end

  def move_to_next_spot(spot)
    @hand.move_to_next_spot
  end
end