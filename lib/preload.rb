require 'preload/version'

require 'preload/array_mixin'

Array.send(:include, Preload::ArrayMixin)
