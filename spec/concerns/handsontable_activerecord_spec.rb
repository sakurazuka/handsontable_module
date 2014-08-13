require 'rails_helper'

RSpec.describe HandsontableActiverecord, :type => :model do

  describe ".handson_load" do
    before do
      left = Left.new(lock_version: 0, num: 100, price: 100)
      left.save!
      @id = left.id
    end
    let(:load_success){ Left.handson_load(:id, :lock_version, :num, :price) }

    it "配列を返す" do
      expect(load_success.class).to eql Array
    end
    it "ヘッダを返す" do
      expect(load_success.first).to eql ["id","lock","数","単価"]
    end
    it "データ本体を返す" do
      expect(load_success.last).to eql [@id,0,100,100]
    end
  end

  describe ".handson_save" do
    context 'create' do

      context 'success' do
        let(:save_success){ Left.handson_save([["id","lock","数","単価"], [nil,0,0,0]]) }
        it '正常終了が返却されること' do
          expect(save_success[:result]).to eq true
          expect(save_success[:message]).to eq [Settings.handson.message.success]
        end
        it 'レコード数が１つ増えていること' do
          expect{ save_success }.to change(Left, :count).by(1)
        end
        it '保存内容が正しいこと' do
          expect(Left.find(1).lock_version).to eq 0
          expect(Left.find(1).num).to eq 0
          expect(Left.find(1).price).to eq 0
        end
      end
      context 'valid error' do
        let(:save_invalid){ Left.handson_save([["id","lock","数","単価"], [nil,0,nil,nil]]) }
        it 'バリデーションエラーが返却されること' do
          expect(save_invalid[:result]).to eq false
          # expect(save_success[:message]).to eq [Settings.handson.message.]
        end
      end
    end

    context 'update' do
      before do
        left = Left.new(lock_version: 0, num: 100, price: 100)
        left.save!
        @id = left.id
      end

      context 'success' do
        let(:save_success){ Left.handson_save([["id","lock","数","単価"], [@id,0,0,0]]) }
        it '正常終了が返却されること' do
          expect(save_success[:result]).to eq true
          expect(save_success[:message]).to eq [Settings.handson.message.success]
        end
        it 'レコード数が増えてないこと' do
          expect{ save_success }.to change(Left, :count).by(0)
        end
        it '保存内容が正しいこと' do
          expect(Left.find(1).lock_version).to eq 0
          expect(Left.find(1).num).to eq 0
          expect(Left.find(1).price).to eq 0
        end
      end
      context 'valid error' do
        let(:save_invalid){ Left.handson_save([["id","lock","数","単価"], [@id,0,nil,nil]]) }
        it 'バリデーションエラーが返却されること' do
          expect(save_invalid[:result]).to eq false
          # expect(save_success[:message]).to eq [Settings.handson.message.]
        end
      end
      context 'lock_version error' do
        let(:save_lock_err){ Left.handson_save([["id","lock","数","単価"], [@id,1,0,0]]) }
        it 'ロックバージョンエラーが返却されること' do
          expect(save_lock_err[:result]).to eq false
          expect(save_lock_err[:message]).to eq [Settings.handson.message.lock_err]
        end
      end
    end
  end
end
