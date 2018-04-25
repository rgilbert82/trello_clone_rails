require 'spec_helper'

describe Comment do
  it { should validate_presence_of(:body) }
  
  it { should belong_to(:user) }
  it { should belong_to(:card) }
end
