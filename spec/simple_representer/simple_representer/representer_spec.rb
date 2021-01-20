require 'spec_helper'
require 'ostruct'
require_relative '../../../lib/simple_representer/representer'

RSpec.describe SimpleRepresenter::Representer do
  class CompanyRepresenter < SimpleRepresenter::Representer
    property :name
  end

  class Representer < SimpleRepresenter::Representer
    property :id
    property :name, if: -> { represented.id > 5 }
    property :name, as: :full_name
    computed :uid
    computed :something, if: -> { options[:user] }
    property :company, representer: CompanyRepresenter

    def uid
      represented.id.to_s + represented.name
    end

    def something
      options[:user].id
    end
  end

  let(:represented_obj) { OpenStruct.new(id: 3, name: 'Jon', company: OpenStruct.new(name: 'SuperCompany')) }
  let(:user) { OpenStruct.new(id: 4) }
  let(:instance) { Representer.new(represented_obj, user: user) }

  describe '#to_h' do
    subject { instance.to_h }

    it do
      expect(subject).to eq({
                              id: 3,
                              full_name: 'Jon',
                              uid: '3Jon',
                              something: 4,
                              company: {
                                name: 'SuperCompany'
                              }
                            })
    end
  end

  describe '#to_json' do
    subject { instance.to_json }

    it do
      expect(subject).to eq('{"id":3,"full_name":"Jon","uid":"3Jon","something":4,"company":{"name":"SuperCompany"}}')
    end
  end

  context 'from hash' do
    let(:represented_obj) { { id: 3, name: 'Jon', company: { name: 'SuperCompany' } } }

    describe '#to_h' do
      subject { instance.to_h }

      it do
        expect(subject).to eq({
                                id: 3,
                                full_name: 'Jon',
                                uid: '3Jon',
                                something: 4,
                                company: {
                                  name: 'SuperCompany'
                                }
                              })
      end
    end
  end

  context 'for collection' do
    let(:represented_obj2) { OpenStruct.new(id: 10, name: 'Bob', company: { name: 'SecondCompany' }) }
    let(:instance) { Representer.for_collection([represented_obj, represented_obj2], user: user) }

    describe '#to_h' do
      subject { instance.to_h }

      it do
        expect(subject).to eq([
                                {
                                  id: 3,
                                  full_name: 'Jon',
                                  uid: '3Jon',
                                  something: 4,
                                  company: {
                                    name: 'SuperCompany'
                                  }
                                },
                                {
                                  id: 10,
                                  full_name: 'Bob',
                                  name: 'Bob',
                                  uid: '10Bob',
                                  something: 4,
                                  company: {
                                    name: 'SecondCompany'
                                  }
                                }
                              ])
      end
    end

    describe '#to_json' do
      subject { instance.to_json }

      it do
        expect(subject).to eq('[{"id":3,"full_name":"Jon","uid":"3Jon","something":4,"company":{"name":"SuperCompany"}},{"id":10,"name":"Bob","full_name":"Bob","uid":"10Bob","something":4,"company":{"name":"SecondCompany"}}]')
      end
    end
  end
end
