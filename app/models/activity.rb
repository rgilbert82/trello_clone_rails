class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :card
  belongs_to :picture, optional: true

  validates_presence_of :description
end
