require 'active_record'

module Preload
  module ArrayMixin
    def preload(*associations)
      return if empty?

      if defined?(ActiveRecord::Associations::Preloader)
        ActiveRecord::Associations::Preloader.new(self, associations).run
      elsif ActiveRecord::Base.respond_to?(:preload_associations)
        first.class.send(:preload_associations, self, associations)
      else
        raise "Unsupported version of ActiveRecord"
      end
    end
  end
end

