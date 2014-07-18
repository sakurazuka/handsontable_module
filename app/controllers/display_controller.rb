class DisplayController < ApplicationController
  def index
    gon.items = [Settings.model.left.values,
                  [1, 0, '2111', 20, '1,000', nil]]
    # gon.items = [Settings.model.left.values,
                  # [nil, 0, '2111', nil, nil, nil],
                  # [nil, 0, '2111', nil, nil, nil]]
  end

  def bulk_update
    follows = params["follows"]
    follows.pop
    # Left.extend(HandsonModule)
    result = Left.handson_save(follows)

    render json: result, layout: false
  end
end
