Fabricator(:list) do
  title { Faker::Name.title }
  archived false
end
