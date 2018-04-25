class List < ActiveRecord::Base
  belongs_to :user
  belongs_to :board

  has_many :cards, :dependent => :destroy

  validates_presence_of :title
end
