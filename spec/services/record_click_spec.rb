require 'rails_helper'

RSpec.describe RecordClick do
  let!(:availability_match) { FactoryGirl.create(:availability_match, available: true) }

  let(:record_click) { RecordClick.new(availability_match, :w) }

  describe '#record' do
    it 'creates a click record' do
      expect { record_click.perform }.to change { AvailabilityMatchClick.count }.by(1)
    end

    it 'sets state on MatchClick' do
      match_click = record_click.perform
      expect(match_click.available).to be(true)
      expect(match_click.from).to eq('w')
    end

    context 'available false' do
      let!(:availability_match) { FactoryGirl.create(:availability_match, available: false) }

      it 'sets state on MatchClick' do
        match_click = record_click.perform
        expect(match_click.available).to be(false)
      end
    end
  end
end
