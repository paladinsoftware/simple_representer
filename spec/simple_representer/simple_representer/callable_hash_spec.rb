require 'spec_helper'
require_relative '../../../lib/simple_representer/callable_hash'

RSpec.describe SimpleRepresenter::CallableHash do
  let(:hash) { original_hash.extend(SimpleRepresenter::CallableHash) }

  context 'hash with symbols' do
    let(:original_hash) { { id: 5 } }

    it 'returns value when used like method' do
      expect(hash.id).to eq(5)
    end

    it 'has defined methods' do
      expect(hash.method(:id)).to be_kind_of(Method)
      expect { hash.method(:something) }.to raise_error(NameError)
    end

    it 'raises error if key not found' do
      expect { hash.something }.to raise_error(NoMethodError)
    end
  end

  context 'hash with strings' do
    let(:original_hash) { { 'id' => 5 } }

    it 'returns value when used like method' do
      expect(hash.id).to eq(5)
    end

    it 'has defined methods' do
      expect(hash.method(:id)).to be_kind_of(Method)
      expect { hash.method(:something) }.to raise_error(NameError)
    end

    it 'raises error if key not found' do
      expect { hash.something }.to raise_error(NoMethodError)
    end
  end
end
