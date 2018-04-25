class User < ActiveRecord::Base
  has_many :boards, :dependent => :destroy
  has_many :lists, :dependent => :destroy
  has_many :cards, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :pictures, :dependent => :destroy
  has_many :payments

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :password
  validates_presence_of :email
  validates_uniqueness_of :email

  has_secure_password validations: false

  before_create :generate_token
  after_create :seed_user

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def self.get_formatted_datetime
    DateTime.now.strftime("%b %d %Y at %I:%M %p")
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def initials
    "#{self.first_name[0].upcase}#{self.last_name[0].upcase}"
  end

  def activate!
    update_column(:active, true)
  end

  def deactivate!
    update_column(:active, false)
  end

  private

  def seed_user
    board1 = Board.create(title: "Welcome Board!", starred: true, user: self)
    board2 = Board.create(title: "Another Board", starred: false, user: self)

    list1 = List.create(title: "Stuff to try(this is a list)", position: 1, archived: false, board: board1, user: self)
    list2 = List.create(title: "List 2", position: 2, archived: false, board: board1, user: self)
    list3 = List.create(title: "Totally awesome empty list!", position: 1, archived: false, board: board2, user: self)

    card1 = Card.create(title: "Cards do many cool things. Click on this card to open it.",
      description: "Click Edit if you'd like to add or edit a card's description. You can also change the card's title (just click it!). Use the buttons on the right to add labels, add a due date, and more.",
      due_date: {"date": "Jun 25", "time": "12:00PM"}, due_date_highlighted: true,
      labels: ["yellow", "orange", "red", "purple", "blue", "green"], position: 1,
      user: self, list: list1, archived: false)

    card2 = Card.create(title: "Another Card!",
      description: "Something here", archived: false, position: 2,
      due_date: {"date": "Jun 5", "time": "12:00PM"}, due_date_highlighted: false,
      labels: ["red", "purple", "blue"], user: self, list: list1)

    card3 = Card.create(title: "Check me out!",
      description: "Hey, it's another card description! Wow!", archived: false, position: 1,
      due_date: {"date": "Oct 2", "time": "11:30AM"}, due_date_highlighted: false,
      labels: ["green"], user: self, list: list2)

    pic1 = Picture.new(user: self, card: card1)
    pic1.image = Rails.root.join("db/images/taco.png").open
    pic1.save!

    Activity.create(comment: false, description: "created this card", date_time: User.get_formatted_datetime, card: card1, user: self, user_name: self.full_name, user_initials: self.initials)
    Activity.create(comment: false, description: "created this card", date_time: User.get_formatted_datetime, card: card2, user: self, user_name: self.full_name, user_initials: self.initials)
    Activity.create(comment: false, description: "created this card", date_time: User.get_formatted_datetime, card: card3, user: self, user_name: self.full_name, user_initials: self.initials)
    Activity.create(comment: false, description: "attached <u>taco.png</u> to this card", date_time: User.get_formatted_datetime, user_name: self.full_name, user_initials: self.initials, card: card1, picture: pic1, user: self)
  end
end
