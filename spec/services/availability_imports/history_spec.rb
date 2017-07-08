require 'rails_helper'

RSpec.describe AvailabilityImports::History do
  let!(:import_previous) { FactoryGirl.create(:availability_import) }
  let!(:import) { FactoryGirl.create(:availability_import, facility: import_previous.facility) }

  let(:history) { AvailabilityImports::History.new(import) }
  let(:sites) { FactoryGirl.create_list(:site, 5) }
  before do
    avails_prev = [
      { availability_import: import_previous, site: sites[0], avail_date: Date.parse('2018/1/1') },
      { availability_import: import_previous, site: sites[0], avail_date: Date.parse('2018/1/5') }, # filled
      { availability_import: import_previous, site: sites[1], avail_date: Date.parse('2018/1/3') },
      { availability_import: import_previous, site: sites[2], avail_date: Date.parse('2018/1/2') },
      { availability_import: import_previous, site: sites[3], avail_date: Date.parse('2018/1/8') }, # filled
      { availability_import: import_previous, site: sites[4], avail_date: Date.parse('2018/1/4') },
    ]

    avails = [
      { availability_import: import, site: sites[0], avail_date: Date.parse('2018/1/1') },
      { availability_import: import, site: sites[0], avail_date: Date.parse('2018/1/2') }, # open
      { availability_import: import, site: sites[1], avail_date: Date.parse('2018/1/1') }, # open
      { availability_import: import, site: sites[1], avail_date: Date.parse('2018/1/3') },
      { availability_import: import, site: sites[2], avail_date: Date.parse('2018/1/2') },
      { availability_import: import, site: sites[3], avail_date: Date.parse('2018/1/3') }, # open
      { availability_import: import, site: sites[4], avail_date: Date.parse('2018/1/4') },
    ]

    (avails + avails_prev).each do |a|
      FactoryGirl.create(:availability, a)
    end
  end

  describe '#import_previous' do
    it 'is the other import' do
      expect(history.import_previous).to eq import_previous
    end
  end

  describe '#create_history' do
    before do
      history.create_history
      import.reload
    end

    it 'saves the newly opened sites' do
      expect(import.history_open.size).to eq(3)
      expect(import.history_open).to include('site_id' => sites[0].id, 'avail_date' => '2018-01-02')
      expect(import.history_open).to include('site_id' => sites[1].id, 'avail_date' => '2018-01-01')
      expect(import.history_open).to include('site_id' => sites[3].id, 'avail_date' => '2018-01-03')
    end

    it 'tracks filled sites' do
      expect(import.history_filled.size).to eq(2)
      expect(import.history_filled).to include('site_id' => sites[0].id, 'avail_date' => '2018-01-05')
      expect(import.history_filled).to include('site_id' => sites[3].id, 'avail_date' => '2018-01-08')
    end
  end
end
