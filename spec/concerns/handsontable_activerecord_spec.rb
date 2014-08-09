require 'rails_helper'

RSpec.describe HandsontableActiverecord, :type => :model do

  describe ".handson_load" do
    it "配列を返す" do
      # expect(Left.handson_load.class).to eql Array
    end
  end

  describe ".handson_save" do
    it "保存が成功すること" do
      expect(Left.handson_save([])).to be_truthy
    end
  end
end
