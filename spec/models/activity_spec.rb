require 'spec_helper'

describe Activity do
  it { should validate_presence_of(:description) }

  it { should belong_to(:card) }
  it { should belong_to(:user) }
end
