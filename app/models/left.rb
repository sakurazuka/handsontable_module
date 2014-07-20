class Left < ActiveRecord::Base
  include HandsontableActiverecord

  validates :num, :price,  presence: true
end
