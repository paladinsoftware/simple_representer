# frozen_string_literal: true

require_relative 'property'
require_relative 'computed'

module SimpleRepresenter
  module Definable
    def self.included(host_class)
      host_class.extend ClassMethods
    end

    module ClassMethods
      def property(field, **options)
        definitions << Property.new(field, default_options.merge(options))
      end

      def computed(field, **options)
        definitions << Computed.new(field, default_options.merge(options))
      end

      def defaults(**options)
        default_options.merge!(options)
      end

      def definitions
        @definitions ||= []
      end

      def default_options
        @default_options ||= {}
      end

      def inherited(subclass)
        super
        subclass.instance_variable_set('@definitions', instance_variable_get('@definitions').clone)
        subclass.instance_variable_set('@default_options', instance_variable_get('@default_options').clone)
      end
    end
  end
end
