class Board < ActiveRecord::Base
  include Sluggable

  belongs_to :user
  has_many :lists, :dependent => :destroy

  validates_presence_of :title
end
