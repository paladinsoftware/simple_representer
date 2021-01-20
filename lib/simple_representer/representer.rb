# frozen_string_literal: true

require 'oj'

require_relative 'callable_hash'
require_relative 'definable'
require_relative 'collection'

module SimpleRepresenter
  class Representer
    include Definable

    attr_reader :represented, :options

    def initialize(represented, **options)
      @represented = represented.is_a?(Hash) ? represented.clone.extend(CallableHash) : represented
      @options = options
    end

    # return hash with symbols as keys
    def to_h
      build_result do |obj, result|
        obj[result[0]] = result[1]
      end
    end
    alias to_hash to_h

    def to_json(*_args)
      ::Oj.generate(to_h)
    end

    def self.for_collection(collection, **options)
      Collection.new(self, collection, options)
    end

    private

    def build_result
      self.class.definitions.each_with_object({}) do |definition, obj|
        result = definition.call(self)
        next unless result

        yield obj, result
      end
    end
  end
end
