require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a forum exists" do
  Forum.create(forum_attributes)
end

describe "Forums Resource" do
  
  describe "index action" do
    it "should respond successfully" do
      visits("/forums").should be_successful
    end
    
    it "should render the proper view" do
      response = visits("/forums")
      response.body.should include("Forums Index")
    end
  end

  describe "show action", :given => 'a forum exists' do
    before do
      @response = visits("/forums/1")
    end
    
    it "should respond successfully" do
      @response.should be_successful
    end
  end
  
  describe "new action" do
    before do
      @response = visits("/forums/new")
    end
    
    it "should respond successfully" do
      @response.should be_successful
    end
    
    it "should render new.html.haml" do
      @response.body.should include("New Forum")
    end
  end
  
  describe "create action" do  
    # it "should fail for duplicate user information" do
    #   response = visit("/forums", :post, :user => user_attributes)
    #   response.status.should == 422
    # end
    
    it 'should fail if invalid' do
      response = visit("/forums", :post, :forum => {:name => ''})
      response.should_not be_successful
      response.status.should == 422
    end
    
    it 'should create successfully' do
      response = visit("/forums", :post, :forum => forum_attributes)
      response.should be_successful
      Forum.first.should_not be_nil
      #response.should redirect(resource(@forum))
    end
  end
  
  describe "edit action", :given => 'a forum exists' do
    before do
      @response = visit("/forums/1/edit")
    end
    
    it "should find the user if it exists" do
      @response.should be_successful
      response = visit("/forums/2/edit")
      response.should_not be_successful
      response.status.should == 404
    end
    
    it 'should render edit.haml.html' do
      @response.body.should include("Edit Forum")
    end
  end
  
  describe "update action", :given => 'a forum exists' do
    before do
      @response = visit("/forums/1", :put, :forum => {:description => 'Dont talk'})
    end
    
    it 'should update forum attributes properly' do
      @response.should be_successful
      Forum.first.description.should == 'Dont talk'
    end
    
    it 'should redirect to show template' do
      @response.headers['Location'] == '/users/1'
    end
    
    it 'should fail if updating with bad data' do
      response = visit("/forums/1", :put, :forum => {:name => ''})
      response.should_not be_successful
      response.status.should == 422
    end
  end
  
  describe "destroy action", :given => 'a forum exists' do
    before do
      @forum = Forum.first
      @forum.should_not be_nil
      @response = visit("/forums/#{@forum.id}", :delete)
    end
    
    it "should delete the forum" do
      redirect_to(resource(:forums))
      Forum.first.should be_nil
    end
  end
  
end
