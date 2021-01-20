# frozen_string_literal: true

module SimpleRepresenter
  module CallableHash
    private

    def method_missing(symbol, *args)
      return self[symbol] if include?(symbol)
      return self[symbol.to_s] if include?(symbol.to_s)

      super
    end

    def respond_to_missing?(symbol, include_private = false)
      include?(symbol) || include?(symbol.to_s) || super
    end
  end
end
