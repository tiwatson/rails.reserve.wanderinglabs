require 'rails_helper'

RSpec.describe AvailabilityRequest, type: :model do
  let(:ar) { FactoryGirl.create :availability_request, details: { water: true } }
  let!(:site) { FactoryGirl.create(:site, facility: ar.facility, ext_site_id: 123, details: { water: true }) }
  let!(:site2) { FactoryGirl.create(:site, facility: ar.facility, ext_site_id: 124, details: { water: false }) }
  let!(:site3) { FactoryGirl.create(:site, facility: ar.facility, ext_site_id: 125, details: { water: false }) }

  describe '#cache_site_ids' do
    it 'updates site ids' do
      expect { ar.cache_site_ids }
        .to change { ar.site_ids }
        .from([])
        .to([site.id.to_s])
    end
  end
end
