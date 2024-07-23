class PlayerActionsService
	include SharedServiceMethods

	def initialize(spot)
		@spot = spot
		@hand = spot.hand
		@shoe = @hand.shoe
		@session = spot.session
	end

	def take_insurance
		@spot.update! insurance: true
	end

	def decline_insurance
		@spot.update! insurance: false
	end

	def double_down
		@spot.double = true
		hit
		@hand.move_to_next_spot
	end

	def hit
		@spot.player_cards << deal_card
		if @spot.busted?
			GradingService.new(@spot).grade!
			@hand.move_to_next_spot
		end
		@spot.save!
	end

	def stand
		@hand.move_to_next_spot
	end

	def split
		raise "You can not split this hand" unless @spot.split_offered?
		
    ActiveRecord::Base.transaction do
      split_card2 = @spot.player_cards.pop
      split_card1 = @spot.player_cards.pop

      sub_spot1 = @spot.sub_spots.create!(
        user: @spot.user,
        session: @session,
        hand: @hand,
        player_cards: [split_card1, deal_card],
        wager: @spot.wager,
        spot_number: @spot.spot_number
      )

      sub_spot2 = @spot.sub_spots.create!(
        user: @spot.user,
        session: @session,
        hand: @hand,
        player_cards: [split_card2],
        wager: @spot.wager,
        spot_number: @spot.spot_number
      )

      @hand.update! current_spot: sub_spot1

      if split_card1[0] == "A"
      	sub_spot2.player_cards << deal_card
      	sub_spot2.save!
      	@hand.move_to_next_spot
      end

      @spot.update! split: true
    end

    true
	end

end