class DisplayController < ApplicationController
  def index
    gon.items = [Settings.model.left.values,
                  [nil, 0, '2111', 10, '1,000', nil]]
  end

  def bulk_update
    follows = params["follows"]
    follows.pop
    Left.extend(HandsonModule)
    Left.handson_save(follows)

    render text: 'test', layout: false
  end
end
