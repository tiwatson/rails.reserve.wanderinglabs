FactoryGirl.define do
  factory :availability do
    # transient do
    #   site_num nil
    # end

    site
    availability_import

    # after(:build) do |availability, evaluator|
    #   availability.site =
    #     Site.find_by(site_num: evaluator.site_num) ||
    #     FactoryGirl.create(:site, site_num: evaluator.site_num)
    # end
  end
end
