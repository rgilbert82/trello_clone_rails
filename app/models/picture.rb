class Picture < ActiveRecord::Base
  belongs_to :user
  belongs_to :card
  has_many :activities, :dependent => :destroy
  validates_presence_of :image
  mount_uploader :image, ImageUploader

  def get_formatted_datetime
    self.created_at.strftime("%b %d %Y at %I:%M %p")
  end
end
