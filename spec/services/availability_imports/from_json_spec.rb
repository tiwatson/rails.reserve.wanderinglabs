require 'rails_helper'

RSpec.describe AvailabilityImports::FromJson do
  let(:import) { FactoryGirl.create(:availability_import) }
  let!(:site1) { FactoryGirl.create(:site, facility: import.facility, ext_site_id: '1') }
  let!(:site2) { FactoryGirl.create(:site, facility: import.facility, ext_site_id: '2') }
  let!(:site3) { FactoryGirl.create(:site, facility: import.facility, ext_site_id: '3') }
  let!(:site4) { FactoryGirl.create(:site, facility: import.facility, ext_site_id: '4') }
  let(:from_json) { AvailabilityImports::FromJson.new(import) }
  let(:body) do
    {
      'results' => {
        '11/24/2017' => ['1', '2'],
        '11/25/2017' => ['2', '3'],
        '11/26/2017' => ['2', '4'],
      },
    }
  end

  describe '#perform' do
    before do
      allow(from_json).to receive(:body) { body }
    end

    it 'Creates Availabilities' do
      expect { from_json.perform }.to change { import.availabilities.count }.by(6)
    end
  end
end
