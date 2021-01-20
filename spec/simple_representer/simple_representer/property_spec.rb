require 'spec_helper'
require_relative '../../../lib/simple_representer/property'

RSpec.describe SimpleRepresenter::Property do
  class NestedRepresenter < SimpleRepresenter::Representer
    property :inside_name
  end

  subject { described_class.new(:name, options).call(representer) }

  let(:representer) { double({ represented: OpenStruct.new(name: 'alfa') }) }

  context 'without arguments' do
    let(:field) { :name }
    let(:options) { {} }

    it { is_expected.to eq([:name, 'alfa']) }
  end

  context 'with condition' do
    context 'condition met' do
      let(:options) { { if: -> { represented.name.start_with?('a') } } }

      it { is_expected.to eq([:name, 'alfa']) }
    end

    context 'condition not met' do
      let(:options) { { if: -> { represented.name.start_with?('b') } } }

      it { is_expected.to be_nil }
    end
  end

  context 'with alias' do
    let(:options) { { as: :name_hehe } }

    it { is_expected.to eq([:name_hehe, 'alfa']) }
  end

  context 'with representer as object' do
    let(:representer) { double({ represented: OpenStruct.new(name: OpenStruct.new(inside_name: 'beta')) }) }
    let(:options) { { representer: NestedRepresenter } }

    it { is_expected.to eq([:name, { inside_name: 'beta' }]) }
  end

  context 'with representer as array of objects' do
    let(:representer) { double({ represented: OpenStruct.new(name: [OpenStruct.new(inside_name: 'alfa'), OpenStruct.new(inside_name: 'beta')]) }) }
    let(:options) { { representer: NestedRepresenter } }

    it { is_expected.to eq([:name, [{ inside_name: 'alfa' }, { inside_name: 'beta' }]]) }
  end
end