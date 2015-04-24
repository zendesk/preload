require 'active_record'

module Preload
  module ArrayMixin
    def pre_load(*associations)
      return if empty?

      if ActiveRecord::VERSION::MAJOR > 4 || (ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR > 0)
        ActiveRecord::Associations::Preloader.new.preload(self, associations)
      elsif defined?(ActiveRecord::Associations::Preloader)
        ActiveRecord::Associations::Preloader.new(self, associations).run
      elsif ActiveRecord::Base.respond_to?(:preload_associations, true)
        first.class.send(:preload_associations, self, associations)
      else
        raise "Unsupported version of ActiveRecord"
      end
    end
  end
end
