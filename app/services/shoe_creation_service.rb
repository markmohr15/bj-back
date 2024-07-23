class ShoeCreationService
  PYTHON_SHUFFLE_URL = 'http://python-service:8000/shuffle'

  def initialize(session)
    @session = session
  end

  def perform
    @session.shoes.create!(shuffled_cards(create_deck))
  end

  private

  def create_deck
    suits = ['H', 'D', 'C', 'S']
    values = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']
    values.product(suits).map {|x| "#{x[0]}#{x[1]}"} * @session.decks
  end

  def shuffled_cards(cards)
    client_seed = SecureRandom.hex(16)
    result = HTTParty.post(PYTHON_SHUFFLE_URL, 
                body: { cards: cards, seed: client_seed}.to_json,
                headers: { 'Content-Type' => 'application/json' } )
    
    if result.ok?
      { cards: result['shuffled_cards'], 
        shuffle_hash: result['shuffle_hash'],
        client_seed: client_seed }
    else
      raise "Failed to shuffle cards"
    end
  end
end
