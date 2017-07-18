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

    context 'second import' do
      let(:import2) { FactoryGirl.create(:availability_import, facility: import.facility) }
      let(:from_json2) { AvailabilityImports::FromJson.new(import2) }

      let(:body2) do
        {
          'results' => {
            '11/24/2017' => ['1', '2'],
            '11/25/2017' => ['2'],
            '11/26/2017' => ['1', '2', '3', '4'],
            '11/27/2017' => ['4'],
          },
        }
      end

      before do
        from_json.perform
        allow(from_json2).to receive(:body) { body2 }
      end

      it 'Creates Availabilities' do
        expect { from_json2.perform }.to change { Availability.count }.by(2)
      end

      it 'updates import_id' do
        expect { from_json2.perform }.to change { Availability.where(availability_import_id: import).count }.to(0)
      end

      context 'import history' do
        before do
          from_json2.perform
          import2.reload
        end

        it 'saves the newly opened sites' do
          expect(import2.history_open.size).to eq(3)
          expect(import2.history_open).to include('site_id' => site1.id, 'avail_date' => '2017-11-26')
          expect(import2.history_open).to include('site_id' => site3.id, 'avail_date' => '2017-11-26')
          expect(import2.history_open).to include('site_id' => site4.id, 'avail_date' => '2017-11-27')
        end

        it 'tracks filled sites' do
          expect(import2.history_filled.size).to eq(1)
          expect(import2.history_filled).to include('site_id' => site3.id, 'avail_date' => '2017-11-25')
        end
      end
    end
  end
end
