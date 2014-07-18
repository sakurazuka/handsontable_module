module HandsonModule
  def handson_save(rows)
    ActiveRecord::Base.transaction do
      header = rows.shift
      colums = header.map{|f| Settings.model.send(self.to_s.underscore).key(f).to_sym}
      save_attributes = rows.map{|r| Hash[*([colums, r].transpose).flatten]}

      err_msg = []
      save_attributes.each do |attribute|
        new_obj = self.new(attribute)
        err_msg << new_obj.errors.full_messages if new_obj.invalid?
      end
      if err_msg.blank?
        save_attributes.each do |attribute|
          if attribute[:id].present?
            self.find(attribute[:id]).update_attributes!(attribute)
          else
            self.new(attribute).save!
          end
        end
        {result: true, message: ['保存しました。']}
      else
        {result: false, message: err_msg.flatten.uniq}
      end
    end
  rescue ActiveRecord::StaleObjectError
    {result: false, message: ['すでに他の人によって編集されています。']}
  rescue => e
    {result: false, message: [e.to_s]}
  end
end
