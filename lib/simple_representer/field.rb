# frozen_string_literal: true

module SimpleRepresenter
  class Field
    attr_reader :field, :options

    def initialize(field, options)
      @field = field.to_sym
      @options = options
    end

    def call(representer)
      return if options[:if] && !representer.instance_exec(&options[:if])

      value = process(representer)
      return if value.nil?

      value = nested_representer(value) if options[:representer]

      [(options[:as] || field).to_sym, value]
    end

    private

    def nested_representer(value)
      return options[:representer].for_collection(value).to_h if value.is_a?(Array)

      options[:representer].new(value).to_h
    end
  end
end
