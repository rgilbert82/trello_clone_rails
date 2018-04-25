Fabricator(:board) do
  title { Faker::Name.title }
  starred 'true'
end
