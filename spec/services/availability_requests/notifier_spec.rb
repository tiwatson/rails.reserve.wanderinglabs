require 'rails_helper'

RSpec.describe AvailabilityRequests::Notifier do
  let(:availability_request) { FactoryGirl.create(:availability_request) }
  let!(:availability_match) do
    FactoryGirl.create(
      :availability_match,
      availability_request: availability_request,
      notified_at: nil,
      available: true
    )
  end
  let(:notifier) { AvailabilityRequests::Notifier.new(availability_request) }

  describe '#needed?' do
    it 'returns true when there are matches to notify about' do
      expect(notifier.needed?).to be true
    end

    context 'already notified' do
      let!(:availability_match) do
        FactoryGirl.create(
          :availability_match,
          availability_request: availability_request,
          notified_at: Time.now,
          available: true
        )
      end

      it 'returns true when there are matches to notify about' do
        expect(notifier.needed?).to be false
      end
    end
  end

  describe '#notifier' do
    before do
      allow(NotifierMailer).to receive(:new_availabilities).and_return(double('NotifierMailer', deliver: true))
    end

    it 'sends an email' do
      expect(NotifierMailer).to receive(:new_availabilities).and_return(double('NotifierMailer', deliver: true))
      notifier.notify
    end

    it 'logs it to the db' do
      expect { notifier.notify }.to change { AvailabilityNotification.count }.by(1)
    end

    it 'updates the notified_at timestamp' do
      expect { notifier.notify }.to(change { availability_match.reload.notified_at })
    end
  end
end
