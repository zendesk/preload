require 'preload/version'

require 'preload/array_mixin'

Array.send(:include, Preload::ArrayMixin)

begin
  require 'will_paginate'
  require 'will_paginate/collection'
  WillPaginate::Collection.send(:include, Preload::ArrayMixin)
rescue LoadError => e
end
