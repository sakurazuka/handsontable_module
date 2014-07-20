class Left < ActiveRecord::Base
  include HandsontableActiverecord

  validates :num, :price,  presence: true

  before_save :calc_amount

  def calc_amount
    self.amount = self.num.to_i * self.price.to_i
  end
end
