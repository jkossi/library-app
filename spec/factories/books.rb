FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Book - #{n}"}
    sequence(:description) { |n| "Book Description - #{n}"}
  end
end
