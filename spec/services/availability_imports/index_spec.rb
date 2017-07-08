require 'rails_helper'

RSpec.describe AvailabilityImports::Index do
  let(:hash) { '123456abc' }
  let(:facility) { FactoryGirl.create(:facility, last_import_hash: '123456abc') }
  let(:import) { AvailabilityImports::Index.new(facility.id, '17_06_08_17_22', hash) }

  describe '#import_needed?' do
    it 'false when hashes are equal' do
      expect(import.import_needed?).to be false
    end

    context 'differing hashes' do
      let(:hash) { 'foobar' }

      it 'true' do
        expect(import.import_needed?).to be true
      end
    end
  end
end
