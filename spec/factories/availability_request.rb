FactoryGirl.define do
  factory :availability_request do
    user
    facility
    status :active
    date_start { Date.today + 30 }
    date_end { Date.today + 60 }
    stay_length 7
  end
end
