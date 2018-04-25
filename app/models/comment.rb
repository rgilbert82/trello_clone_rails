class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :card

  validates_presence_of :body
end
