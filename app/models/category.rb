class Category
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :description, String
  
  has n, :forums
  
end