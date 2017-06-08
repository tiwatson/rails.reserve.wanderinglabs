require 'rails_helper'

RSpec.describe AvailabilityRequest, type: :model do

  describe '#cache_site_ids' do
    let(:ar) { FactoryGirl.create :availability_request, water: true }
    let!(:site) { FactoryGirl.create(:site, facility: ar.facility, ext_site_id: 123, water: true) }
    let!(:site2) { FactoryGirl.create(:site, facility: ar.facility, ext_site_id: 124, water: false) }
    let!(:site3) { FactoryGirl.create(:site, facility: ar.facility, ext_site_id: 125, water: false) }

    it 'updates site ids' do
      expect { ar.cache_site_ids }
        .to change { ar.site_ids }
        .from([])
        .to([site.id.to_s])
    end
  end
end
