class User < ActiveRecord::Base

   #search
   def self.search(search)
       where("name LIKE ? OR identity LIKE ?","%#{search}%", "%#{search}%")
   end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #Relationship
  has_many :collection_assigments, dependent: :destroy
  has_and_belongs_to_many :classrooms
  belongs_to :role
  has_many :topics, dependent: :destroy
  has_many :units, dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :quizzes

  #validation
  validates :identity, uniqueness: true


  #feed time line

  def feed
    Micropost.from_users_followed_by(self)
  end

  #relathionship
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  #photo
  has_attached_file :photo, :style => {:thumb => 'x100', :croppable => '600x600>', :big => '1000x1000>'}, :url => "/system/:attachment/:id/:style/:basename.:extension",
  :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpg', 'image/png', 'image/jpeg']

  #role
  validates_presence_of :name
  before_save :assign_role

  def assign_role
    self.role = Role.find_by name: "Guess" if self.role.nil?
  end

  def admin?
    self.role.name == "Admin"
  end

  def lecturer?
    self.role.name == "Lecturer"
  end

  def student?
    self.role.name == "Student"
  end

  #Messaging
  acts_as_messageable

  def mailboxer_name
    self.name
  end

  def mailboxer_email(object)
    self.email
  end
end
