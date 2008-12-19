class Topic
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String
  property :description, String
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_length :title, :min => 5
  
  has n, :posts
  belongs_to :forum, :class_name => 'Forum'
  belongs_to :user
end