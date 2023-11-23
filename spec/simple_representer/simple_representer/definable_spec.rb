require 'spec_helper'
require_relative '../../../lib/simple_representer/definable'

RSpec.describe SimpleRepresenter::Definable do
  class Test
    include SimpleRepresenter::Definable

    defaults render_nil: true
    defaults render_if_key_found: true

    property :name, if: -> { true }
    computed :id, as: :uid
  end

  subject { Test.definitions }

  it 'has proper definitions' do
    expect(subject.size).to eq(2)
    expect(subject[0]).to be_kind_of(SimpleRepresenter::Property)
    expect(subject[0].field).to eq(:name)
    expect(subject[0].options.keys).to include(:if, :render_nil, :render_if_key_found)
    expect(subject[1]).to be_kind_of(SimpleRepresenter::Computed)
    expect(subject[1].field).to eq(:id)
    expect(subject[1].options).to eq({ as: :uid, render_nil: true, render_if_key_found: true })
  end
end
