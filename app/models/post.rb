class Post
  include DataMapper::Resource
  
  property :id,         Serial
  property :title,      String
  property :content,    Text
  property :created_at, DateTime
  property :updated_at, DateTime
  
  validates_length :content, :min => 5
end