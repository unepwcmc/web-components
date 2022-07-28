FactoryBot.define do
  factory :country do
    sequence(:name) { |n| "Country #{n}" }
    sequence(:iso3) { |n| "C#{n.to_s.rjust(2, '0')}" }
  end
end
