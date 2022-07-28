require 'active_record'

module Preload
  module ArrayMixin
    def pre_load(*associations)
      return if empty?

      if ActiveRecord::VERSION::MAJOR >= 7
        ActiveRecord::Associations::Preloader.new(records: self, associations: associations).call
      elsif ActiveRecord::VERSION::MAJOR >= 5
        ActiveRecord::Associations::Preloader.new.preload(self, associations)
      else
        raise "Unsupported version of ActiveRecord"
      end
    end
  end
end
