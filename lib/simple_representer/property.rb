# frozen_string_literal: true

require_relative 'field'

module SimpleRepresenter
  class Property < Field
    def process(representer)
      return nil unless representer.represented.respond_to?(field)

      representer.represented.public_send(field)
    end
  end
end
