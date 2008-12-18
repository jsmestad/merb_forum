require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a topic exists" do
  Topic.create(topic_attributes)
end

describe "Topics Resource" do
  
  before(:each) do
    Forum.create(forum_attributes)
  end
  
  describe "index action" do
    it "should respond successfully" do
      visits("/forums/1/topics").should be_successful
    end
    
    it "should render the proper view" do
      response = visits("/forums/1/topics")
      response.body.should include("Forum Index")
    end
  end

  describe "show action", :given => 'a topic exists' do
    before do
      @response = visits("/forums/1/topics/1")
    end
    
    it "should respond successfully" do
      @response.should be_successful
    end
  end
  
  describe "new action" do
    before do
      @response = visits("/forums/1/topics/new")
    end
    
    it "should respond successfully" do
      @response.should be_successful
    end
    
    it "should render new.html.haml" do
      @response.body.should include("New Topic")
    end
  end
  
  describe "create action" do  
    # it "should fail for duplicate user information" do
    #   response = visit("/forums", :post, :user => user_attributes)
    #   response.status.should == 422
    # end
    
    it 'should fail if invalid' do
      response = visit("/forums/1/topics", :post, :topic => {:title => ''}, :post => {:content => 'the dude was here'} )
      response.should_not be_successful
      response.status.should == 422
    end
    
    it 'should create successfully' do
      response = visit("/forums/1/topics", :post, :topic => topic_attributes, :post => {:content => 'the dude was here'})
      response.should be_successful
      Topic.first.should_not be_nil
      #response.should redirect(resource(@forum))
    end
  end
  
  describe "edit action", :given => 'a topic exists' do
    before do
      @response = visit("/forums/1/topics/1/edit")
    end
    
    it "should find the user if it exists" do
      @response.should be_successful
      response = visit("/forums/1/topics/12/edit")
      response.should_not be_successful
      response.status.should == 404
    end
    
    it 'should render edit.haml.html' do
      @response.body.should include("Edit Topic")
    end
  end
  
  describe "update action", :given => 'a topic exists' do
    before do
      @response = visit("/forums/1/topics/1", :put, :topic => {:description => 'Dont talk'})
    end
    
    it 'should update forum attributes properly' do
      @response.should be_successful
      Topic.first.description.should == 'Dont talk'
    end
    
    it 'should redirect to show template' do
      @response.headers['Location'] == '/forums/1/topics/1'
    end
    
    it 'should fail if updating with bad data' do
      response = visit("/forums/1/topics/1", :put, :topic => {:title => ''})
      response.should_not be_successful
      response.status.should == 422
    end
  end
  
  describe "destroy action", :given => 'a topic exists' do
    before do
      @topic = Topic.first
      @topic.should_not be_nil
      @response = visit("/forums/#{@topic.forum.id}/topics/#{@topic.id}", :delete)
    end
    
    it "should delete the topic" do
      #redirect_to(url(:forum, 1))
      Topic.first.should be_nil
    end
  end
  
end
