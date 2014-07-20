class DisplayController < ApplicationController

  def index
    gon.items = Left.where.not(id: nil).handson_load(:id, :lock_version, :section, :num, :price, :amount)
  end

  def bulk_update
    follows = params["follows"]
    follows.pop
    follows.each_with_index{|f,i| f[5] = f[3].to_i * f[4].to_i unless i == 0}
    result = Left.handson_save(follows)

    render json: result, layout: false
  end
end
