Fabricator(:comment) do
  body { Faker::Name.title }
  user_name 'Bob Smith'
  user_initials 'BS'
  date_time { Faker::Date.forward(1) }
end
