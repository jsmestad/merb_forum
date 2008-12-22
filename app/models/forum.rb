class Forum
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :nullable => false
  property :description, String

  validates_length :name, :min => 5
  
  has n, :topics
  belongs_to :category
end