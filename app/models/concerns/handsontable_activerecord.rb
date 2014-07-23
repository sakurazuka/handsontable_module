module HandsontableActiverecord
  extend ActiveSupport::Concern

  module ClassMethods
    def handson_load(*columns)
      self.pluck(columns.join(',').to_sym).unshift(handson_header(columns))
    end

    # def handson_load_no_head(*columns)
      # self.pluck(columns.join(',').to_sym)
    # end

    # def handson_save_no_head(rows, columns, indexes=[])
      # rows = handson_select(rows, indexes) if indexes.present?

      # attributes = handson_attributes(rows, columns)
      # err_msg = handson_valid(attributes)

      # if err_msg.blank?
        # handson_update_or_create!(attributes)
        # {result: true, message: [Settings.handson.message.success]}
      # else
        # {result: false, message: err_msg.flatten.uniq}
      # end
    # rescue ActiveRecord::StaleObjectError
      # {result: false, message: [Settings.handson.message.lock_err]}
    # rescue => e
      # {result: false, message: [e.to_s]}
    # end

    def handson_save(rows, *indexes)
      rows = handson_select(rows, indexes) if indexes.present?

      header = rows.shift
      attributes = handson_attributes(rows, handson_colums(header))
      err_msg = handson_valid(attributes)

      if err_msg.blank?
        handson_update_or_create!(attributes)
        {result: true, message: [Settings.handson.message.success]}
      else
        {result: false, message: err_msg.flatten.uniq}
      end
    rescue ActiveRecord::StaleObjectError
      {result: false, message: [Settings.handson.message.lock_err]}
    rescue => e
      {result: false, message: [e.to_s]}
    end


  private
    def handson_header(columns)
      # columns.map{|h| Settings.handson.send(self.name.underscore).send(h.to_s)}
      columns.map{|h| I18n.t("activerecord.attributes.#{self.name.underscore}.#{h.to_s}")}
    end

    def handson_colums(header)
      # header.map{|f| Settings.handson.send(self.name.underscore).key(f).to_sym}
      header.map{|f| I18n.t("activerecord.attributes.#{self.name.underscore}").key(f).to_sym}
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

    def handson_select(rows, indexes)
      rows.map{|r| r.values_at(*indexes)}
    end
  end
end
