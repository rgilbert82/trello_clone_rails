Fabricator(:card) do
  title { Faker::Name.title }
  archived false
  description 'something here'
end
