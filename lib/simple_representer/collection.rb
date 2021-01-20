# frozen_string_literal: true

require 'oj'

module SimpleRepresenter
  class Collection
    attr_reader :representer, :collection, :options

    def initialize(representer, collection = [], options = {})
      @representer = representer
      @collection = collection
      @options = options
    end

    def to_h
      collection.map { |elem| representer.new(elem, **options).to_h }
    end
    alias to_hash to_h

    def to_json(*_args)
      ::Oj.generate(to_h)
    end
  end
end
