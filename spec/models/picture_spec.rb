require 'spec_helper'

describe Picture do
  it { should validate_presence_of(:image) }

  it { should belong_to(:user) }
  it { should belong_to(:card) }
  it { should have_many(:activities).dependent(:destroy) }
end
