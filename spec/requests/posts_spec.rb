require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a post exists" do
  Post.create(post_attributes)
end

describe "Posts Resource" do
  
  before(:each) do
    create_user
    login('Test', 'password')
    Forum.create(forum_attributes)
    Topic.create(topic_attributes)
  end

  # describe "show action", :given => 'a topic exists' do
  #   before do
  #     @response = visit("/forums/1/topics/1")
  #   end
  #   
  #   it "should respond successfully" do
  #     @response.should be_successful
  #   end
  # end
  
  describe "new action" do
    before do
      @response = visit("/forums/1/topics/1/posts/new")
    end
    
    it "should respond successfully" do
      @response.should be_successful
    end
    
    it "should render new.html.haml" do
      @response.body.should include("New Reply")
    end
  end
  
  describe "create action" do  
    # it "should fail for duplicate user information" do
    #   response = visit("/forums", :post, :user => user_attributes)
    #   response.status.should == 422
    # end
    
    it 'should fail if invalid' do
      response = visit("/forums/1/topics/1/posts", :post, :post => {:content => ''} )
      response.should_not be_successful
      response.status.should == 422
    end
    
    it 'should create successfully' do
      response = visit("/forums/1/topics/1/posts", :post, :post => post_attributes.merge(:user_id => ''))
      response.should be_successful
      Post.first.should_not be_nil
      #response.should redirect(resource(@forum))
    end
  end
  
  describe "edit action", :given => 'a post exists' do
    before do
      @response = visit("/forums/1/topics/1/posts/1/edit")
    end
    
    it "should find the user if it exists" do
      @response.should be_successful
      response = visit("/forums/1/topics/1/posts/2/edit")
      response.should_not be_successful
      response.status.should == 404
    end
    
    it 'should render edit.haml.html' do
      @response.body.should include("Edit Post")
    end
  end
 
  describe "update action", :given => 'a post exists' do
    before do
      @response = visit("/forums/1/topics/1/posts/1", :put, :post => {:content => 'I own you.'})
    end
 
    it 'should update post attributes properly' do
      @response.should be_successful
      Post.first.content.should == 'I own you.'
    end
 
    it 'should redirect to show template' do
      @response.headers['Location'] == '/forums/1/topics/1'
    end
 
    it 'should fail if updating with bad data' do
      response = visit("/forums/1/topics/1/posts/1", :put, :post => {:content => ''})
      response.should_not be_successful
      response.status.should == 422
    end
  end
  
  describe "destroy action", :given => 'a post exists' do
    before do
      @post = Post.first
      @post.should_not be_nil
      @response = visit("/forums/#{@post.topic.forum.id}/topics/#{@post.topic.id}/posts/#{@post.id}", :delete)
    end
    
    it "should delete the post" do
      #redirect_to(url(:forum, 1))
      Post.first.should be_nil
    end
  end
  
end
