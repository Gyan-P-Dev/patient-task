FactoryBot.define do
    factory :patient do
      first_name { "John" }
      last_name { "Doe" }
      email { "john.doe@example.com" }
      date_of_birth { 25.years.ago }
      next_appointment_date { 1.day.from_now }
  
      trait :upcoming do
        next_appointment_date { 1.day.from_now }
      end
  
      trait :past do
        next_appointment_date { 1.week.ago }
      end
    end
  end
  