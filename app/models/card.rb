class Card < ActiveRecord::Base
  include Sluggable

  belongs_to :user
  belongs_to :list

  has_many :comments, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :pictures, :dependent => :destroy

  serialize :due_date
  serialize :labels, Array

  validates_presence_of :title
end
