require 'rails_helper'

RSpec.describe AvailabilityMatcher::Finder do
  let(:import) { FactoryGirl.create(:availability_import) }
  let(:availability_request) { FactoryGirl.create(:availability_request, facility: import.facility) }
  let!(:site) { FactoryGirl.create(:site, facility: import.facility) }
  let!(:site1) { FactoryGirl.create(:site, facility: import.facility) }
  let(:finder) { AvailabilityMatcher::Finder.new(import, availability_request) }
  let!(:am) { FactoryGirl.create(:availability_match, availability_request: availability_request, site: site, length: 3, avail_date: Date.today, available: true) }

  describe '#matching_availabilities' do
    before do
      allow(finder).to receive(:search) do
        [
          {
            site_id: site.id,
            length: 3,
            avail_min: Date.today,
          },
          {
            site_id: site1.id,
            length: 2,
            avail_min: Date.today + 30.days,
          },
        ]
      end
    end

    it 'has two matches' do
      expect(finder.matching_availabilities.size).to be(2)
    end

    it 'creates match / does not duplicate previous' do
      expect { finder.matching_availabilities }.to change { AvailabilityMatch.count }.by(1)
    end

    it 'does not duplicate matches' do
      expect { finder.matching_availabilities }.to change { AvailabilityMatch.count }.by(1)
      expect { finder.matching_availabilities }.to change { AvailabilityMatch.count }.by(0)
    end
  end
end
