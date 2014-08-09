class Left < ActiveRecord::Base
  include HandsontableActiverecord

  has_many :centers
  has_one :center
  has_many :rights
  has_one :right

  validates :num, :price,  presence: true
end
