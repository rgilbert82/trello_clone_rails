module Sluggable
  extend ActiveSupport::Concern

  included do
    before_create :generate_slug!
  end

  def to_param
    # to_param automatically returns the id for routing purposes.
    # this is overriding to_param to return the slug instead.
    self.slug
  end

  def generate_slug!
    the_slug = to_slug
    obj = self.class.find_by slug: the_slug

    while obj && obj != self
      the_slug = to_slug
      obj = self.class.find_by slug: the_slug
    end

    self.slug = the_slug
  end

  def to_slug
    SecureRandom.urlsafe_base64(6)
  end
end
