# frozen_string_literal: true

module SimpleRepresenter
  class Field
    attr_reader :field, :options

    def initialize(field, options)
      @field = field.to_sym
      @options = options
    end

    def call(representer)
      @representer = representer

      return if options[:if] && !representer.instance_exec(&options[:if])

      value = process(representer)
      value = options[:default] if value.nil?
      value = nested_representer(value) if options[:representer] && !value.nil?

      build_field(value)
    end

    private

    attr_reader :representer

    def nested_representer(value)
      return options[:representer].for_collection(value).to_h if value.is_a?(Array)

      options[:representer].new(value).to_h
    end

    def build_field(value)
      return if value.nil? && !options.fetch(:render_nil, false)
      return if value.nil? && options.fetch(:render_if_key_found, false) && !representer.represented.respond_to?(field)

      [(options[:as] || field).to_sym, value]
    end
  end
end
