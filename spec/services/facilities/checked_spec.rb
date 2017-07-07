require 'rails_helper'

RSpec.describe Facilities::Checked do
  let(:facility) { FactoryGirl.create(:facility) }
  let!(:availability_request) { FactoryGirl.create(:availability_request, facility: facility) }
  let!(:availability_request2) { FactoryGirl.create(:availability_request, facility: facility, checked_count: 17) }
  let!(:availability_request3) { FactoryGirl.create(:availability_request, facility: facility, date_end: Date.yesterday) }

  let(:checked) { Facilities::Checked.new(facility) }

  describe '#mask_as' do
    it 'increments the checked_count by 1' do
      expect { checked.mark_as }.to change { availability_request.reload.checked_count }.by(1)
    end

    it 'increments two at a time' do
      checked.mark_as
      expect(availability_request2.reload.checked_count).to be > availability_request.reload.checked_count
    end

    it 'Does not increment a non active' do
      expect { checked.mark_as }.to_not change { availability_request3.reload.checked_count }
    end

    it 'Updates the checked_at timestamp' do
      expect { checked.mark_as }.to change { availability_request.reload.checked_at }
    end
  end
end
