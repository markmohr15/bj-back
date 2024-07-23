module Card
  CARD_VALUES = {
    '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, 
    '7' => 7, '8' => 8, '9' => 9, 'T' => 10,
    'J' => 10, 'Q' => 10, 'K' => 10, 'A' => 11
  }

  module_function

  def value(card)
    CARD_VALUES[card[0]]
  end

  def is_ten?(card)
    ['T', 'J', 'Q', 'K'].include? card[0]
  end

  def is_ace?(card)
    card[0] == 'A'
  end

  def suit(card)
    card[1]
  end
end