require 'spec_helper'

describe Payment do
  it { should belong_to(:user) }
end
