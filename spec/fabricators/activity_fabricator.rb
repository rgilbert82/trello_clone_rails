Fabricator(:activity) do
  description { Faker::Name.title }
  comment false
  user_name 'Bob Smith'
  user_initials 'BS'
  date_time { Faker::Date.forward(1) }
end
