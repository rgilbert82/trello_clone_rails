require 'spec_helper'

describe Card do
  it { should validate_presence_of(:title) }

  it { should belong_to(:user) }
  it { should belong_to(:list) }

  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:activities).dependent(:destroy) }
  it { should have_many(:pictures).dependent(:destroy) }
end
