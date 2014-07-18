class Left < ActiveRecord::Base
  validates :num, :price,  presence: true
end
