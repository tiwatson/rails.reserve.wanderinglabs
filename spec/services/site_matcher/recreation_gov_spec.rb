require 'rails_helper'

RSpec.describe SiteMatcher::RecreationGov do
  let(:facility) { FactoryGirl.create :facility }
  let(:site_matcher) { SiteMatcher::RecreationGov.new(facility.id, details) }
  let!(:site) { FactoryGirl.create(:site, facility: facility, ext_site_id: 123, details: { water: true }) }
  let!(:site2) { FactoryGirl.create(:site, facility: facility, ext_site_id: 124, details: { water: false }) }
  let!(:site3) { FactoryGirl.create(:site, facility: facility, ext_site_id: 125, details: { water: false }) }

  describe '#matching_site_ids' do
    context 'water: true' do
      let(:details) { { water: true } }
      it { expect(site_matcher.matching_site_ids.size).to eq(1) }
      it { expect(site_matcher.matching_site_ids).to include(site.id) }
    end

    context 'water: false' do
      let(:details) { { water: false } }
      it { expect(site_matcher.matching_site_ids.size).to eq(2) }
      it { expect(site_matcher.matching_site_ids).to include(site2.id) }
    end

    context 'water: nil' do
      let(:details) { nil }
      it { expect(site_matcher.matching_site_ids.size).to eq(3) }
    end
  end
end
