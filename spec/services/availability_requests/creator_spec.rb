require 'rails_helper'

RSpec.describe AvailabilityRequests::Notifier do
  let(:facility) { FactoryGirl.create(:facility) }
  let(:params) do
    {
      email: 'test@example.com',
      facility_id: facility.id,
      stay_length: 3,
      date_start: '2017-07-04T18:00:00.000Z',
      date_end: '2017-07-28T18:00:00.000Z',
    }
  end

  let(:creator) { AvailabilityRequests::Creator.new(params) }

  describe '#create' do
    it 'successfully creates the request' do
      expect { creator.create }.to change { AvailabilityRequest.count }.by(1)
    end

    it 'creates a user' do
      expect { creator.create }.to change { User.where(email: 'test@example.com').count }.by(1)
    end
  end
end
