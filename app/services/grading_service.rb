class GradingService
	def initialize(spot)
		@spot = spot
		@hand = spot.hand
		@session = spot.session
	end

	def grade!
		if @spot.split?
			split
		elsif @spot.blackjack? && @hand.blackjack?
			pushed
		elsif @hand.blackjack?
			lost
		elsif @spot.blackjack?
			bj_won
		elsif @spot.busted?
			lost
		elsif @hand.busted?
			won
		elsif @spot.hand_value == @hand.hand_value
			pushed
		elsif @spot.hand_value > @hand.hand_value
			won
		elsif @spot.hand_value < @hand.hand_value
			lost
		else
			raise 'Could not grade'
		end
	end

	private

	def split
		@spot.update! result: "split_hand"
	end

	def lost
		@spot.update! result: "loss", profit: @spot.profit - wager_amount
	end

	def won
		@spot.update! result: "win", profit: @spot.profit + wager_amount
	end

	def pushed
		@spot.update! result: "push"
	end

	def bj_won
		@spot.update! result: "win", profit: @spot.profit + wager_amount * blackjack_multiplier
	end

	def double_multiplier
		@spot.double? ? 2 : 1
	end

	def blackjack_multiplier
		@session.six_five? ? 1.2 : 1.5
	end

	def wager_amount
		@spot.wager * double_multiplier
	end

end