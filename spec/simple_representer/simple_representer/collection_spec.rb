require 'spec_helper'
require_relative '../../../lib/simple_representer/representer'
require_relative '../../../lib/simple_representer/collection'

RSpec.describe SimpleRepresenter::Collection do
  class TestRepresenter < SimpleRepresenter::Representer
    property :id
    computed :name

    def name
      options[:name]
    end
  end

  let(:collection) { [OpenStruct.new(id: 5), { 'id' => 6 }] }
  let(:instance) { SimpleRepresenter::Collection.new(TestRepresenter, collection, name: 'SomeName') }

  describe '#to_h' do
    subject { instance.to_h }

    it { is_expected.to eq([{ id: 5, name: 'SomeName' }, { id: 6, name: 'SomeName' }]) }
  end

  describe '#to_json' do
    subject { instance.to_json }

    it { is_expected.to eq('[{"id":5,"name":"SomeName"},{"id":6,"name":"SomeName"}]') }
  end
end
