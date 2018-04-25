require 'spec_helper'

describe List do
  it { should validate_presence_of(:title) }

  it { should belong_to(:user) }
  it { should belong_to(:board) }

  it { should have_many(:cards).dependent(:destroy) }
end
