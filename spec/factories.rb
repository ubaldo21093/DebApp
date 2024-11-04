FactoryBot.define do
    factory(:student) do
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      major { Student::VALID_MAJORS.sample } 
      expected_graduation_date { Faker::Date.between(from: 2.years.ago, to: 2.years.from_now) }
      email { "student1@msudenver.edu" }
      password { "password" }
      password_confirmation { "password" }
    end
   end
   