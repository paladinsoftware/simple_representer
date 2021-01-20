# frozen_string_literal: true

require_relative 'field'

module SimpleRepresenter
  class Computed < Field
    def process(representer)
      representer.public_send(field)
    end
  end
end
