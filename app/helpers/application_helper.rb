module ApplicationHelper
  def get_card(id)
    Card.find(id)
  end
end
