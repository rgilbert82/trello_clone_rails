Fabricator(:user) do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  email { Faker::Internet.email }
  password 'password'
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end
