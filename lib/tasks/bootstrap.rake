namespace :db do
  desc "populate database with defaults"
  
  task :bootstrap => :merb_env do
    file = File.dirname(__FILE__) / ".." / ".." / "lib" / "default_data.yml"
    data = YAML::load_file(file)
    
    `rake db:automigrate`
    User.create(data["user"])
    Forum.create(data["forum"])
    Topic.create(data["topic"])
    Post.create(data["post1"])
    Post.create(data["post2"])
  end
end