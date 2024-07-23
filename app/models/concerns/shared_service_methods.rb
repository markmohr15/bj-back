module SharedServiceMethods 
	extend ActiveSupport::Concern

  def deal_card
    @shoe.deal_card
  end

end
