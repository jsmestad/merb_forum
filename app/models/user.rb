# This is a default user class used to activate merb-auth.  Feel free to change from a User to 
# Some other class, or to remove it altogether.  If removed, merb-auth may not work by default.
#
# Don't forget that by default the salted_user mixin is used from merb-more
# You'll need to setup your db as per the salted_user mixin, and you'll need
# To use :password, and :password_confirmation when creating a user
#
# see merb/merb-auth/setup.rb to see how to disable the salted_user mixin
# 
# You will need to setup your database and create a user.
class User
  include DataMapper::Resource
  
  property :id,     Serial
  property :login,  String, :nullable => false, :unique => true
  property :email,  String, :nullable => false, :unique => true
  property :identity_url, String,               :unique => true
  property :created_at,   DateTime
  property :updated_at,   DateTime
  
  validates_format :email, :as => :email_address
  
  has n, :topics
  has n, :posts
  
  def password_required?
    identity_url.nil?
  end
  
end
