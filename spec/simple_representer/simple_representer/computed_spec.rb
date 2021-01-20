require 'spec_helper'
require_relative '../../../lib/simple_representer/representer'
require_relative '../../../lib/simple_representer/computed'

RSpec.describe SimpleRepresenter::Computed do
  subject { described_class.new(field, options).call(representer) }

  class NestedRepresenter < SimpleRepresenter::Representer
    property :inside_name
  end

  class Representer < SimpleRepresenter::Representer
    def name_upcase
      represented.name.upcase
    end

    def nested_names
      represented.nested_names.select { |name| name.id.odd? }
    end

    def nested_name
      represented.nested_names.find { |name| name.id.even? }
    end
  end

  let(:representer) { Representer.new(OpenStruct.new(name: 'alfa')) }
  let(:field) { :name_upcase }

  context 'without arguments' do
    let(:options) { {} }

    it { is_expected.to eq([:name_upcase, 'ALFA']) }
  end

  context 'with condition' do
    context 'condition met' do
      let(:options) { { if: -> { represented.name.start_with?('a') } } }

      it { is_expected.to eq([:name_upcase, 'ALFA']) }
    end

    context 'condition not met' do
      let(:options) { { if: -> { represented.name.start_with?('b') } } }

      it { is_expected.to be_nil }
    end
  end

  context 'with alias' do
    let(:options) { { as: :name } }

    it { is_expected.to eq([:name, 'ALFA']) }
  end

  context 'with representer' do
    let(:representer) { Representer.new(OpenStruct.new(name: 'not_alfa', nested_names: nested_names)) }
    let(:nested_names) do
      [OpenStruct.new(id: 1, inside_name: 'alfa'), OpenStruct.new(id: 2, inside_name: 'beta'), OpenStruct.new(id: 3, inside_name: 'gamma')]
    end
    let(:options) { { representer: NestedRepresenter } }

    context 'as object' do
      let(:field) { :nested_name }

      it { is_expected.to eq([:nested_name, { inside_name: 'beta'} ]) }
    end

    context 'as array of objects' do
      let(:field) { :nested_names }

      it { is_expected.to eq([:nested_names, [{ inside_name: 'alfa'}, { inside_name: 'gamma'}] ]) }
    end
  end
end
