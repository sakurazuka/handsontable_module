class DisplayController < ApplicationController

  def index
    gon.items = Left.where.not(id: nil).handson_load(:id, :lock_version, :section, :num, :price, :amount)
  end

  def bulk_update
    follows = params["follows"]
    follows.pop
    result = Left.handson_save(follows)

    render json: result, layout: false
  end
end
