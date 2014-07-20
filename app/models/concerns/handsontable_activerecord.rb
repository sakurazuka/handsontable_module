module HandsontableActiverecord
  extend ActiveSupport::Concern

  module ClassMethods
    def handson_load(*columns)
      self.pluck(columns.join(',').to_sym).unshift(handson_header(columns))
    end

    def handson_save(rows)
      header = rows.shift
      attributes = handson_attributes(rows, handson_colums(header))
      err_msg = handson_valid(attributes)

      if err_msg.blank?
        handson_update_or_create!(attributes)
        {result: true, message: ['保存しました。']}
      else
        {result: false, message: err_msg.flatten.uniq}
      end
    rescue ActiveRecord::StaleObjectError
      {result: false, message: ['すでに他の人によって編集されています。']}
    rescue => e
      {result: false, message: [e.to_s]}
    end


  private
    def handson_header(columns)
      columns.map{|h| Settings.handson.send(self.name.underscore).send(h.to_s)}
    end

    def handson_colums(header)
      header.map{|f| Settings.handson.send(self.name.underscore).key(f).to_sym}
    end

    def handson_attributes(rows, columns)
      rows.map{|r| Hash[*([columns, r].transpose).flatten]}
    end

    def handson_valid(attributes)
      err_msg = []
      attributes.each do |attribute|
        new_obj = self.new(attribute)
        err_msg << new_obj.errors.full_messages if new_obj.invalid?
      end
      err_msg
    end

    def handson_update_or_create!(attributes)
      ActiveRecord::Base.transaction do
        builds = []

        attributes.each do |attribute|
          if self.find_by(id: attribute[:id]).present?
            handson_update!(attribute)
          else
            builds << handson_build(attribute)
          end
        end

        self.import(builds)
      end
    end

    def handson_update!(attribute)
      self.find(attribute[:id]).update_attributes!(attribute)
    end

    def handson_build(attribute)
      attribute.delete(:id)
      attribute.delete(:lock_version)
      self.new(attribute)
    end
  end
end
