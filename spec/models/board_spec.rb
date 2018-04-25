require 'spec_helper'

describe Board do
  it { should validate_presence_of(:title) }

  it { should belong_to(:user) }
  it { should have_many(:lists).dependent(:destroy) }
end
