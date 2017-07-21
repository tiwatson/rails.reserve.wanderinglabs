require 'rails_helper'

RSpec.describe AvailabilityMatcher::Search do
  let(:import) { FactoryGirl.create(:availability_import) }
  let(:site1) { FactoryGirl.create(:site) }
  let(:site2) { FactoryGirl.create(:site) }
  let!(:availabilities) do
    [
      FactoryGirl.create(:availability, availability_import: import, site: site1, avail_date: Date.strptime('01/13/2017', '%m/%d/%Y')),
      FactoryGirl.create(:availability, availability_import: import, site: site1, avail_date: Date.strptime('01/14/2017', '%m/%d/%Y')),
      FactoryGirl.create(:availability, availability_import: import, site: site1, avail_date: Date.strptime('01/15/2017', '%m/%d/%Y')),
      FactoryGirl.create(:availability, availability_import: import, site: site1, avail_date: Date.strptime('01/16/2017', '%m/%d/%Y')),

      FactoryGirl.create(:availability, availability_import: import, site: site1, avail_date: Date.strptime('01/18/2017', '%m/%d/%Y')),
      FactoryGirl.create(:availability, availability_import: import, site: site1, avail_date: Date.strptime('01/19/2017', '%m/%d/%Y')),
      FactoryGirl.create(:availability, availability_import: import, site: site1, avail_date: Date.strptime('01/21/2017', '%m/%d/%Y')),

      FactoryGirl.create(:availability, availability_import: import, site: site2, avail_date: Date.strptime('01/14/2017', '%m/%d/%Y')),
    ]
  end

  let(:search) { AvailabilityMatcher::Search.new(availability_request, import.id).search }

  describe '#search' do
    context 'single night with availability on both sides' do
      let(:availability_request) do
        FactoryGirl.create(
          :availability_request,
          date_start: Date.strptime('01/14/2017', '%m/%d/%Y'),
          date_end: Date.strptime('01/14/2017', '%m/%d/%Y'),
          stay_length: 1,
          site_ids: [site1.id]
        )
      end

      it 'has a single match' do
        expect(search.count).to eq(1)
        expect(search.first[:site_id]).to eq(site1.id)
        expect(search.first[:avail_min]).to eq('2017-01-14')
        expect(search.first[:length]).to eq(3)
      end
    end

    context '4 night block' do
      let(:availability_request) do
        FactoryGirl.create(
          :availability_request,
          date_start: Date.strptime('01/13/2017', '%m/%d/%Y'),
          date_end: Date.strptime('01/31/2017', '%m/%d/%Y'),
          stay_length: 4,
          site_ids: [site1.id]
        )
      end

      it 'has a single match' do
        expect(search.count).to eq(1)
        expect(search.first[:site_id]).to eq(site1.id)
        expect(search.first[:avail_min]).to eq('2017-01-13')
        expect(search.first[:length]).to eq(4)
      end
    end

    context '2 night block ending on an open availability' do
      let(:availability_request) do
        FactoryGirl.create(
          :availability_request,
          date_start: Date.strptime('01/15/2017', '%m/%d/%Y'),
          date_end: Date.strptime('01/18/2017', '%m/%d/%Y'),
          stay_length: 2,
          site_ids: [site1.id]
        )
      end

      it 'has two matches' do
        expect(search.count).to eq(2)
        expect(search.any? { |s| s[:avail_min] == '2017-01-18' }).to be true
        expect(search.any? { |s| s[:length] == 2 }).to be true
        expect(search.any? { |s| s[:site_id] == site1.id }).to be true
      end
    end

    context 'Only arrival on Sunday' do
      let(:availability_request) do
        FactoryGirl.create(
          :availability_request,
          date_start: Date.strptime('01/13/2017', '%m/%d/%Y'),
          date_end: Date.strptime('01/31/2017', '%m/%d/%Y'),
          stay_length: 1,
          site_ids: [site1.id, site2.id],
          arrival_days: [6]
        )
      end

      it 'has only 3 matches' do
        expect(search.count).to eq(3)
        expect(search.any? { |s| s[:avail_min] == '2017-01-14' && s[:site_id] == site2.id }).to be true
        expect(search.any? { |s| s[:avail_min] == '2017-01-21' }).to be true
        expect(search.any? { |s| s[:avail_min] == '2017-01-18' }).to be false
      end
    end
  end

  describe 'Matching bug' do
    let!(:availabilities) do
      [
        FactoryGirl.create(:availability, availability_import: import, site: site2, avail_date: Date.strptime('11/14/2017', '%m/%d/%Y')),
        FactoryGirl.create(:availability, availability_import: import, site: site2, avail_date: Date.strptime('11/16/2017', '%m/%d/%Y')),

        FactoryGirl.create(:availability, availability_import: import, site: site1, avail_date: Date.strptime('11/18/2017', '%m/%d/%Y')),
        FactoryGirl.create(:availability, availability_import: import, site: site1, avail_date: Date.strptime('11/25/2017', '%m/%d/%Y')),

        FactoryGirl.create(:availability, availability_import: import, site: site2, avail_date: Date.strptime('11/18/2017', '%m/%d/%Y')),
        FactoryGirl.create(:availability, availability_import: import, site: site2, avail_date: Date.strptime('11/19/2017', '%m/%d/%Y')),
        FactoryGirl.create(:availability, availability_import: import, site: site2, avail_date: Date.strptime('11/20/2017', '%m/%d/%Y')),
        FactoryGirl.create(:availability, availability_import: import, site: site2, avail_date: Date.strptime('11/21/2017', '%m/%d/%Y')),
        FactoryGirl.create(:availability, availability_import: import, site: site2, avail_date: Date.strptime('11/22/2017', '%m/%d/%Y')),
        FactoryGirl.create(:availability, availability_import: import, site: site2, avail_date: Date.strptime('11/23/2017', '%m/%d/%Y')),
        FactoryGirl.create(:availability, availability_import: import, site: site2, avail_date: Date.strptime('11/24/2017', '%m/%d/%Y')),
      ]
    end

    let(:availability_request) do
      FactoryGirl.create(
        :availability_request,
        date_start: Date.strptime('11/10/2017', '%m/%d/%Y'),
        date_end: Date.strptime('11/25/2017', '%m/%d/%Y'),
        stay_length: 1,
        site_ids: [site1.id, site2.id]
      )
    end

    it 'matches correctly' do
      expect(search.any? { |s| s[:avail_min] == '2017-11-18' && s[:site_id] == site1.id && s[:length] == 1 }).to be true
      expect(search.any? { |s| s[:avail_min] == '2017-11-18' && s[:site_id] == site2.id && s[:length] == 7 }).to be true
    end
  end
end
