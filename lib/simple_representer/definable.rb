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
        definitions << Property.new(field, options)
      end

      def computed(field, **options)
        definitions << Computed.new(field, options)
      end

      def definitions
        @definitions ||= []
      end

      def inherited(subclass)
        super
        subclass.instance_variable_set('@definitions', instance_variable_get('@definitions'))
      end
    end
  end
end
