require 'rails_helper'

RSpec.describe Facility, type: :model do
  describe '#scrape_start' do
    let(:facility) { FactoryGirl.create(:facility, booking_window: 182) }

    context 'start ago' do
      let!(:ar) { FactoryGirl.create(:availability_request, facility: facility, date_start: 1.week.ago, date_end: 2.months.from_now) }
      let!(:ar2) { FactoryGirl.create(:availability_request, facility: facility, date_start: 1.month.from_now, date_end: 2.months.from_now) }
      it 'is today if request date in past' do
        expect(facility.scrape_start.to_s).to eq(Date.today.to_s)
      end
    end

    context 'start future' do
      let!(:ar) { FactoryGirl.create(:availability_request, facility: facility, date_start: 1.month.from_now, date_end: 2.months.from_now) }
      let!(:ar2) { FactoryGirl.create(:availability_request, facility: facility, date_start: 2.month.from_now, date_end: 3.months.from_now) }
      it 'is future if request date in future' do
        expect(facility.scrape_start.to_s).to eq(1.month.from_now.to_date.to_s)
      end
    end
  end

  describe '#scrape_start' do
    let(:facility) { FactoryGirl.create(:facility, booking_window: 182) }

    context 'end less booking' do
      let!(:ar) { FactoryGirl.create(:availability_request, facility: facility, date_start: 1.week.ago, date_end: 2.months.from_now) }
      let!(:ar2) { FactoryGirl.create(:availability_request, facility: facility, date_start: 1.month.from_now, date_end: 3.months.from_now) }
      it 'is date_end' do
        expect(facility.scrape_end.to_s).to eq(3.months.from_now.to_date.to_s)
      end
    end

    context 'end after booking' do
      let!(:ar) { FactoryGirl.create(:availability_request, facility: facility, date_start: 1.month.from_now, date_end: 24.months.from_now) }
      let!(:ar2) { FactoryGirl.create(:availability_request, facility: facility, date_start: 2.month.ago, date_end: 1.months.ago) }
      it 'is booking window' do
        expect(facility.scrape_end.to_s).to eq(facility.booking_end.to_s)
      end
    end
  end
end
