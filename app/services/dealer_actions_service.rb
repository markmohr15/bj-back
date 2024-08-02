class DealerActionsService
	include SharedServiceMethods

	def initialize(hand)
		@hand = hand
		@spots = hand.spots.in_progress
		@shoe = hand.shoe
	end

	def perform
		return @hand unless @spots.any?

		while should_hit?
			hit
		end

		@hand.save! if @hand.dealer_cards_changed?
		grade
		@hand
	end

	private

	def hit
		@hand.dealer_cards << deal_card
	end

	def should_hit?
    @hand.hand_value < 17 || should_hit_soft_17?
  end

	def should_hit_soft_17?
  	@hand.hand_value == 17 && @hand.soft_hand? && !@shoe.session.stand_17
	end

	def grade
		ActiveRecord::Base.transaction do
			@spots.each do |spot|
				GradingService.new(spot).grade!
			end
		end
	end
end

