module CardValuator
  extend ActiveSupport::Concern

  include Card

  class_methods do
    def valuate_cards(field)
      class_eval do
        define_method(:cards_field) { field }
      end
    end
  end

  def card_value(card)
    CARD_VALUES[card[0..-2]]
  end

  def hand_value
    cards = send(cards_field)
    return 0 if cards.nil? || cards.empty?

    total = 0
    aces = 0

    cards.each do |card|
      if Card.is_ace?(card)
        aces += 1
        total += 11
      else
        total += Card.value(card)
      end
    end

    aces.times do
      total -= 10 if total > 21
    end

    total
  end

  def ten_ace?
    cards = send(cards_field)
    cards.length == 2 && Card.is_ten?(cards[0]) && Card.is_ace?(cards[1])
  end

  def blackjack?
    cards = send(cards_field)
    return false if cards.nil? || cards.empty?

    if self.is_a?(Spot) && self.parent_spot.present?
      # This is a sub-spot (result of a split), so it can't be a blackjack
      return false
    end

    cards.length == 2 && hand_value == 21
  end

  def busted?
    hand_value > 21
  end

  def soft_hand?
    cards = send(cards_field)
    return false if cards.nil? || cards.empty?

    aces = cards.count { |card| Card.is_ace?(card) }
    return false if aces == 0

    non_ace_total = cards.reject { |card| Card.is_ace?(card) }.sum { |card| Card.value(card) }
    
    (non_ace_total + 11 + (aces - 1)) <= 21
  end

end