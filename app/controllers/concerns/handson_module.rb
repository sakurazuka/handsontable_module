module HandsonModule
  def handson_save(rows)
    ActiveRecord::Base.transaction do
      header = rows.shift
      colums = header.map{|f| Settings.model.send(self.to_s.underscore).key(f).to_sym}
      rows.each do |row|
        ary = [colums, row].transpose
        save_attributes = Hash[*ary.flatten]
        if save_attributes[:id].present?
          self.find(save_attributes[:id]).update_attributes!(save_attributes)
        else
          self.new(save_attributes).save!
        end
      end
    end
    {result: true, message: nil}
  rescue => e
    {result: false, message: e.to_s}
  end
end
