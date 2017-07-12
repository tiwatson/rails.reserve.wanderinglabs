require 'rails_helper'

RSpec.describe AvailabilityMatch, type: :model do
  let(:match) { FactoryGirl.create(:availability_match) }

  describe '#find_by_base62' do
    it 'given base62 returns the instance' do
      base62 = Base62.encode(match.id)
      instance = AvailabilityMatch.find_by_base62(base62)
      expect(instance.id).to eq(match.id)
    end
  end
end
